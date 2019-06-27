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
`gzip -dc file.vcf.gz | grep "^#CHROM" -m1 | tr "\t" "\n" | tail -n+10 | wc -l`

##### grep with colour
`gzip -dc RefChr20.vcf.gz | grep -F "0.578,0.414" --color`

##### some `less` and `ls` arguments
`less -S` #print lines nicely
`ls -a` #see hidden files too
`ls -l` #see permissions
`ls -lh` #see file size

##### find in the current directory file.txt
`find . -name "file.txt"`

##### disc usage 
`du -hc *.bgz` #human readable total size of the bgz files
`df -lm .` #in the folder

##### initialize environment before `sort` commands that are followed by `join`
`LC_ALL=C; export LC_ALL`

##### append an extra column with a string of 1s
`awk '{print $0,"1" }' file.txt > file1.txt` 

##### change uppercase to lowercase
`tr '[:upper:]' '[:lower:]' < inputfile.txt > outputfile.txt`

##### Beagle output extract at position 33514465
`zgrep -E "CHROM|33514465" chr20.vcf.gz  | cut -f 2,4,5,9,14`
#Note: for genotypes 0=Ref; 1=Alt

##### count how many lines in a vcf.gz, not including lines that start with #
`zgrep -vE ^# file.vcf.gz | wc -l`

##### view only indels
`zgrep -v -E "^[^:]+:[0-9]+_[ATCG]/[ATCG]_" file.gz | less -S`

##### view only A/T SNPs
`zgrep -E "^22:[0-9]+_A/T" file.gz | less -S`

##### view line for a variant (e.g. chr22:16188597) in tabixed vcf.gz
`tabix Mytabixedfile.vcf.gz chr22:16188597 | less -S` 
