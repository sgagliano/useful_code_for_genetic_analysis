#!/bin/bash
#SBATCH --job-name=GWAS
#SBATCH --output=../LOGS/epacts-CaseControl.log

shopt -s expand_aliases
alias epacts="/net/snowwhite/home/sarahgag/EPACTSlive/bin/epacts"


epacts single --vcf chr1.vcf.gz chr2.vcf.gz chr3.vcf.gz chr4.vcf.gz chr5.vcf.gz chr6.vcf.gz chr7.vcf.gz chr8.vcf.gz chr9.vcf.gz chr10.vcf.gz chr11.vcf.gz chr12.vcf.gz chr13.vcf.gz chr14.vcf.gz chr15.vcf.gz chr16.vcf.gz chr17.vcf.gz chr18.vcf.gz chr19.vcf.gz chr20.vcf.gz chr21.vcf.gz chr22.vcf.gz chrX.vcf.gz \
--sepchr --ref /data/local/ref/gotcloud.ref/hg38/hs38DH.fa --unit 100000 --ped MyPheno.ped --min-maf 1e-10 --pheno Pheno --cov Sex --cov PC1 --cov PC2 --test b.firth --out ../output-CaseControl/epacts --run 10
