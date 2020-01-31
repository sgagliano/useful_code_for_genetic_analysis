import gzip

#CHROM  POS     ID      REF     ALT [etc.]
##The ID column is a "." We want to replace the "." with chr:pos_REF/ALT

def AddChrPosAlleles(inGZVCF, outGZVCF):
    with gzip.GzipFile(inGZVCF, 'r') as iz, gzip.GzipFile(outGZVCF, 'w') as oz:
        for line in iz:
            if line.startswith('#'):
                oz.write(line)
            else:   
                fields = line.split('\t')
                alts = fields[4].split(',')
                if len(alts) > 1:
                    print "Multiple Alleles found %s %s" % (fields[0], fields[1])
                    break
                ID = fields[0] + ":" + fields[1] + "_" + fields[3] + "/" + alts[0]
                
                if fields[2] == ".":
                    fields[2] = ID
                
                oz.write("\t".join(fields))     

inGZVCF= "MyFile.vcf.gz"
outGZVCF="MyFile-withids.vcf.gz"

if __name__ == '__main__':
   AddChrPosAlleles(inGZVCF, outGZVCF)
