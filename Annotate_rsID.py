import gzip
import sys
import re
import argparse
import pysam
from collections import namedtuple
from contextlib import closing

argparser = argparse.ArgumentParser('Annotates associations with rsIDs based on chromosome and position.')
argparser.add_argument('--in', metavar = 'file', dest = 'in_file', required = True, type = str, help = 'Input file with association results e.g. METAL format. Input must be compressed with gzip.')
argparser.add_argument('--out', metavar = 'file', dest = 'out_file', required = True, type = str, help = 'Output file name. RsId is appended to the original fields. Output is compressed with gzip.')
argparser.add_argument('--sep', metavar = 'name', dest = 'sep', required = True, choices = ['comma', 'semicolon', 'tab', 'whitespace'], help = 'Fields separator. Supported values: comma, semicolon, tab, whitespace.')
argparser.add_argument('--chrom-field', metavar = 'name', dest = 'chrom_field_regex', required = True, type = str, nargs = '+', help = 'First value is the field name that stores chromosome name. Optionally, second value is the regular expression to extract chromosome name e.g. --chrom-field ID "^([^:]+)" will extract chr11 from chr11:71822_A1/A2 stored in ID field.')
argparser.add_argument('--position-field', metavar = 'name', dest = 'position_field_regex', required = True, type = str, nargs = '+', help = 'First value is the field name that stores chromosomal position in base-pairs. Optionally, second value is the regular expression to extract position value e.g. --position-field ID "^[^:]+:([0-9]+)" will extract 71822 from chr11:71822_A1/A2 stored in ID field.')
argparser.add_argument('--allele1-field', metavar = 'name', dest = 'allele1_field_regex', required = True, type = str, nargs = '+', help = 'First value is the field name that stores allele1 (reference or effect allele). Optionally, second value is the regular expression to extract allele value e.g. --allele1-field ID "^[^:]+:[0-9]+_([^/]+)" will extract A1 from chr11:71822_A1/A2 stored in ID field.')
argparser.add_argument('--allele2-field', metavar = 'name', dest = 'allele2_field_regex', required = True, type = str, nargs = '+', help = 'First value is the field name that stores allele2 (alternate or non-effect allele). Optionally, second value is the regular expression to extract allele value e.g. --allele2-field ID "([^/]+)$" will extract A2 from chr11:71822_A1/A2 value stored in ID field.')
argparser.add_argument('--vcf', metavar = 'name', dest = 'in_vcf', required = True, type = str, help = 'VCF file from dbSNP (or any other) database indexed with tabix.') 

Region = namedtuple('Region', ['chromosome', 'positions'])
Variant = namedtuple('Variant', ['rsid', 'reference', 'alternate']) 

def load_region(in_vcf, chrom, start_bp, end_bp):
   if start_bp is not None and start_bp > 0:
      start_bp -= 1
   region = Region(chrom, dict())
   with closing(pysam.Tabixfile(in_vcf)) as tabix:
      for row in tabix.fetch(chrom, start_bp, end_bp):
         fields = row.rstrip().split('\t')
         position = long(fields[1])
         # to avoid tabix bug: sometimes position before start_bp is included.
         if start_bp is not None and position <= start_bp:
            continue
         chrom = fields[0]
         rsid = fields[2]
         if rsid == '.':
            continue
         ref_allele = fields[3]
         alt_alleles = set(fields[4].split(','))
        
         if position not in region.positions:
            region.positions[position] = list()
         region.positions[position].append(Variant(rsid, ref_allele, alt_alleles))
   return region


def annotate(in_file, chrom_field_regex, position_field_regex, allele1_field_regex, allele2_field_regex, sep, in_vcf, out_file):
   if sep == 'tab':
      sep_char = '\t'
   elif sep == 'whitespace':
      sep_char = ' '
   elif sep == 'comma':
      sep_char = ','
   elif sep == 'semicolon':
      sep_char = ';'
   else:
      raise Exception('Field separator %s is not supported!' % sep)

   chrom_field = chrom_field_regex[0]
   chrom_regex = None
   position_field = position_field_regex[0]
   position_regex = None
   allele1_field = allele1_field_regex[0]
   allele1_regex = None
   allele2_field = allele2_field_regex[0]
   allele2_regex = None

   if len(chrom_field_regex) > 1:
      chrom_regex = re.compile(chrom_field_regex[1])
   if len(position_field_regex) > 1:
      position_regex = re.compile(position_field_regex[1])
   if len(allele1_field_regex) > 1:
      allele1_regex = re.compile(allele1_field_regex[1])
   if len(allele2_field_regex) > 1:
      allele2_regex = re.compile(allele2_field_regex[1])

   with gzip.GzipFile(in_file, 'r') as ifile, gzip.GzipFile(out_file, 'w') as ofile:
      line = ifile.readline()
      if line is None:
         return
      header = line.rstrip().split(sep_char)

      try:
         chrom_field_idx = header.index(chrom_field)
      except ValueError:
         raise Exception('Field \'%s\' was not found in input file!' % chrom_field)

      try:
         position_field_idx = header.index(position_field)
      except ValueError:
         raise Exception('Field \'%s\' was not found in input file!' % position_field)

      try:
         allele1_field_idx = header.index(allele1_field)
      except ValueError:
         raise Exception('Field \'%s\' was not found in input file!' % allele1_field)

      try:
         allele2_field_idx = header.index(allele2_field)
      except ValueError:
         raise Exception('Field \'%s\' was not found in input file!' % allele2_field)

      ofile.write('%s' % sep_char.join(header))
      ofile.write('%cRsId\n' % sep_char)

      region_chrom = ''
      region_start_position = sys.maxint
      region_end_position = -1
      region = None
      region_step_size = 1000000

      for line in ifile:
         fields = line.rstrip().split(sep_char)

         if chrom_regex is not None:
            match = chrom_regex.search(fields[chrom_field_idx])
            if match is None or not match.group(1):
               raise Exception('Error while extracting chromosome name from %s!' % fields[chrom_field_idx])
            chrom = match.group(1)
         else:
            chrom = fields[chrom_field_idx]

         if position_regex is not None:
            match = position_regex.search(fields[position_field_idx])
            if match is None or not match.group(1):
               raise Exception('Error while extracting chromosomal position from %s!' % fields[position_field_idx])
            position = match.group(1)
         else:
            position = fields[position_field_idx]

         try:
            position = long(position)
         except ValueError:
            raise Exception('Error while extracting and casting to integer chromosomal position from %s!' % fields[position_field_idx])

         if allele1_regex is not None:
            match = allele1_regex.search(fields[allele1_field_idx])
            if match is None or not match.group(1):
               raise Exception('Error while extracting allele1 from %s!' % fields[allele1_field_idx])
            allele1 = match.group(1).upper()
         else:
            allele1 = fields[allele1_field_idx].upper()

         if allele2_regex is not None:
            match = allele2_regex.search(fields[allele2_field_idx])
            if match is None or not match.group(1):
               raise Exception('Error while extracting allele2 from %s!' % fields[allele2_field_idx])
            allele2 = match.group(1).upper()
         else:
            allele2 = fields[allele2_field_idx].upper()

         if region_chrom != chrom or position < region_start_position or region_end_position < position:
            region_chrom = chrom
            region_start_position = position - region_step_size if region_step_size < position else 1
            region_end_position = position + region_step_size
            region = load_region(in_vcf, region_chrom, region_start_position, region_end_position)   

         variants = region.positions.get(position, None)
         if variants is None:
            rsid = 'NA'
         else:
            rsid = 'NA'
            for variant in variants:
               if allele1 == variant.reference and allele2 in variant.alternate:
                  rsid = variant.rsid
                  break
               elif allele2 == variant.reference and allele1 in variant.alternate:
                  rsid = variant.rsid
                  break
         ofile.write('%s' % sep_char.join(fields))
         ofile.write('%c%s\n' % (sep_char, rsid))


if __name__ == '__main__':
   args = argparser.parse_args()
   annotate(args.in_file, args.chrom_field_regex, args.position_field_regex, args.allele1_field_regex, args.allele2_field_regex, args.sep, args.in_vcf, args.out_file)
