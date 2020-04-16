#python2
#Run like so
#for CHR in `seq 1 22`
#do
#        sbatch --mem=8000 --job-name=count${CHR} --time=50:00:00 --partition=main --wrap="python singletons_per_individual.py --in chr${CHR}.bcf --individuals sample.list --bed ../data/chr${CHR}.txt --out ../output/chr${CHR}.out" -o ../logs/singgenes_${CHR}.log
#done


import sys
import argparse
import gzip
import pysam
from collections import Counter

argparser = argparse.ArgumentParser(description = 'Counts singletons per individual in specified regions.')
argparser.add_argument('--in', '-i', metavar = 'file', dest = 'in_VCF', required = True, help = 'Input VCF/BCF.')
argparser.add_argument('--individuals', '-n', metavar = 'file', dest = 'individuals', required = True, help = 'List of individuals to use.')
argparser.add_argument('--bed', '-b', metavar = 'file', dest = 'in_BED', required = True, help = 'List of regions in BED format.')
argparser.add_argument('--out', '-o', metavar = 'file', dest = 'out_file', required = True, help = 'Output file.')


def read_individuals(filename):
    with open(filename, 'r') as ifile:
        for line in ifile:
            individual = line.rstrip()
            if individual:
                yield individual


def read_BED(filename):
    with open(filename, 'r') as ifile:
        for line in ifile:
            if line.startswith('browser') or line.startswith('track'):
                continue
            fields = line.rstrip().split('\t')
            yield (fields[0], int(fields[1]), int(fields[2]))


if __name__ == '__main__':
   args = argparser.parse_args()
   input_individuals = list(read_individuals(args.individuals))
   regions = list(read_BED(args.in_BED))
   singletons = Counter()
   with pysam.VariantFile(args.in_VCF) as ifile:
       vcf_samples = set((ifile.header.samples))
       if not all(individual in vcf_samples for individual in input_individuals):
           raise Exception("Not all individuals from the provided list are present in the VCF/BCF.")
       ifile.subset_samples(input_individuals)
       for chrom, start, stop in regions:
           if ifile.get_tid(chrom) < 0: # check if chromosome is in VCF/BCF file
               if chrom.startswith('chr'): # append or remove 'chr' prefix if neccessary
                   fetched = ifile.fetch(chrom[3:], start - 1, stop)
               else:
                   fetched = ifile.fetch('chr' + chrom, start - 1, stop)
           else:
                fetched = ifile.fetch(chrom, start - 1, stop)
           for record in fetched:
               if 'PASS' not in record.filter: # do not use non-PASS
                   continue
               alt_carriers = dict((i, Counter()) for i, alt in enumerate(record.alts, 1))
               for individual, genotype in record.samples.iteritems():
                   for i in genotype.allele_indices:
                       if i > 0:
                           alt_carriers[i].update((individual,))
               for i, individuals in alt_carriers.iteritems():
                   ac = sum(individuals.values())
                   if ac == 0: # skip monomorphic variants which arose after subsetting individuals
                       continue
                   if ac == 1: # count singleton
                       for individual in individuals.keys():
                           singletons.update((individual, ))
           sys.stdout.write('Processed region {}:{}-{}\n'.format(chrom, start, stop))
           sys.stdout.flush()
   with open(args.out_file, 'w') as ofile:
       ofile.write('SAMPLE_ID\tN_SINGLETONS\n')
       for individual in input_individuals:
           ofile.write('{}\t{}\n'.format(individual, singletons[individual]))
