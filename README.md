# useful_unix_one_liners_and_more

##### find replace; e.g. find X, replace with 23
`sed -i 's/X/23/' file.txt` 

##### change space to tab
`perl -p -i -e 's/ /\t/g' file.txt` 

##### add a prefix to the beginning of each line
`sed -i -e 's/^/prefix/' file.txt` 

##### add a suffix to the end of each line, and write it out as a new file
`sed 's/$/suffix/' file.txt > new-file.txt`

##### print the number of individuals in a VCF.gz file
###### option 1 `gzip -dc file.vcf.gz | grep "^#CHROM" -m1 | tr "\t" "\n" | tail -n+10 | wc -l`
###### option 2 `bcftools view -h file.vcf.gz | tail -n1 | cut -f10- | wc -w`

##### split a file (cmds.txt) into separate files of 1000 rows each, add numeric suffixes starting at 0 to file output name
`split -l 1000 -d cmds.txt cmds.split.` 

##### grep with colour
`gzip -dc RefChr20.vcf.gz | grep -F "0.578,0.414" --color`

##### for loops
`for $i in trait1 trait2 trait3; do; --insert code here--; done`

`for $CHR in` \`seq 1 22\`; `do; --insert code here--; done`

`for ((i=1;i<=22;i++)); do; --insert code here--; done` #start at 1, go to 22, increment by 1

##### some `less` and `ls` arguments
###### print lines nicely `less -S` 
###### see hidden files too `ls -a`
###### see permissions `ls -l` 
###### see file size `ls -lh`

##### find in the current directory file.txt
`find . -name "file.txt"`

##### disc usage 
###### human readable total size of the .bgz files `du -hc *.bgz` 
###### within the current directory `df -lm .`
###### total size of directory (e.g. all the files within) `df -sh <directory> .`

##### initialize environment before `sort` commands that are followed by `join`
`LC_ALL=C; export LC_ALL`

##### append an extra column with a string of 1s
`awk '{print $0,"1" }' file.txt > file1.txt` 

##### change uppercase to lowercase
`tr '[:upper:]' '[:lower:]' < inputfile.txt > outputfile.txt`

##### Beagle output extract at position 33514465
`zgrep -E "CHROM|33514465" chr20.vcf.gz  | cut -f 2,4,5,9,14`
###### Note: for genotypes 0=Ref; 1=Alt

##### count how many lines in a vcf.gz, not including lines that start with #
`zgrep -vE ^# file.vcf.gz | wc -l`

##### view only indels
`zgrep -v -E "^[^:]+:[0-9]+_[ATCG]/[ATCG]_" file.gz | less -S`

##### view only A/T SNPs
`zgrep -E "^22:[0-9]+_A/T" file.gz | less -S`

##### view line for a variant (e.g. chr22:16188597) in tabixed vcf.gz
`tabix Mytabixedfile.vcf.gz chr22:16188597 | less -S` 

#### change chr header in a vcf
`bcftools annotate --rename-chrs chr_rename.txt` where `chr_name.txt` contains a list like
```
1 chr1
2 chr2
3 chr3
4 chr4
5 chr5
6 chr6
```

#### rsID to chr:bp (GRCh37 or GRCh38) and vice versa
SNPnexus https://www.snp-nexus.org/v4/

#### Some Useful GWAS Scripts in the Code section; also more in these repositories:
https://github.com/ilarsf/gwasTools (and forked version: https://github.com/bnwolford/gwasTools)
https://github.com/hyunminkang/apigenome Hyun Min Kang's Big data genomics analysis libraries & tools
<p>Carlo Sidore's Sequence Analysis Tutorial: https://genome.sph.umich.edu/wiki/Tutorial:_Low_Pass_Sequence_Analysis

#### RANDOM
online tool to merge the multiple JPEGs together https://www.imgonline.com.ua/eng/combine-two-images-into-one.php

visualization of a table of data, Sparkler: http://bipolar-project.sph.umich.edu/html/sparkler/ 

LZ load your own data: https://abought.github.io/locuszoom-tabix/ (you'll need to bgzip/tabix your GWAS files to use)

quick look-up of heritability estimates from twin studies: http://match.ctglab.nl/#/home

GWAS atlas: https://atlas.ctglab.nl

Pattern recognition and machine learning: https://github.com/ctgk/PRML/blob/master/README.md
