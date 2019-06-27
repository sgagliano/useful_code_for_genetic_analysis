# useful_unix_one_liners

`sed -i 's/X/23/' file.txt` #Find replace; e.g. Find X, replace with 23

`perl -p -i -e 's/ /\t/g' file.txt` #change space to tab

`sed -i -e 's/^/prefix/' file.txt` #add a prefix to the beginning of each line

`sed 's/$/suffix/' file.txt > new-file.txt` #add a suffix to the end of each line, and write it out as a new file

`gzip -dc file.vcf.gz | grep "^#CHROM" -m1 | tr "\t" "\n" | tail -n+10 | wc -l` #print the number of individuals in a VCF.gz file

`gzip -dc RefChr20.vcf.gz | grep -F "0.578,0.414" --color` #grep with colour

`less -S` #print lines nicely
`ls -a` #see hidden files too
`ls -l` #see permissions
`ls -lh` #see file size

`find . -name "file.txt"` #find in the current directory file.txt

#disc usage 
`du -hc *.bgz` #human readable total size of the bgz files
`df -lm .` #in the folder

`LC_ALL=C; export LC_ALL` #initialize before `sort` commands that are followed by `join`

`awk '{print $0,"1" }' file.txt > file1.txt` #append an extra column with a string of 1s

`tr '[:upper:]' '[:lower:]' < inputfile.txt > outputfile.txt` #change uppercase to lowercase

`zgrep -E "CHROM|33514465" chr20.vcf.gz  | cut -f 2,4,5,9,14` #Beagle output extract at position 33514465
#Note: for genotypes 0=Ref; 1=Alt

`zgrep -vE ^# file.vcf.gz | wc -l` #count how many lines in a vcf.gz, not including lines that start with #

`zgrep -v -E "^[^:]+:[0-9]+_[ATCG]/[ATCG]_" file.gz | less -S` #view only indels

`zgrep -E "^22:[0-9]+_A/T" file.gz | less -S` #view only A/T SNPs

`tabix Mytabixedfile.vcf.gz chr22:16188597 | less -S` #view line for a variant (e.g. chr22:16188597) in tabixed vcf.gz 
