#get the frequencies variants from MyFile.{bed,bim,fam}
#variants listed in VariantsList.txt
#for 1000 random subsets of people (all have the same N) ${num}.IndstoKeep.txt (e.g. created using `Permute.R`)

while read variant; do
        echo $variant
        for num in `seq 1 1000`
        do
        plink-1.9 --bfile MyFile --keep ${num}.IndstoKeep.txt --snp $variant --freq --out ../output/${variant}.${num}.IndstoKeep
        done
done < VariantsList.txt
