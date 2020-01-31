#DESCRIPTION: strip existing header from a .VCF and replace with another header 

#put new header into a file; e.g. by extracting it from a bgzipped and tabixed vcf (next line), or making the file manually
#tabix -H File2ExtractHeader.vcf.gz > new_header.txt

prefix=$1

#Example usage: ./Replace_VCFheader.sh mydata

gzip -dc ${prefix}.vcf.gz | grep -v "^#" - | cat new_header.txt - | bgzip -c > ${prefix}-newhead.vcf.gz
