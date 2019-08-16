CHR=$1

vcftools --gzvcf Myfile-chr${CHR}.filtered.PASS.beagled.vcf.gz --FILTER-summary --stdout > chr${CHR}-seq-tstv
