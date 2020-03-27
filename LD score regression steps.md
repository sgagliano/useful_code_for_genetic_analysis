*notes: need pandas 0.20.1 or earlier, and need python2

## How to get the LD score intercept and heritability using LD score regression

#### Resources: 
The wiki is a great starting place: https://github.com/bulik/ldsc/wiki

Starting point: summary statistics and basic info about what’s in it (i.e. numbers of cases and controls, effect size, etc.). 
Note that it is fine if this file is gzipped. 

#### Step #1: 
Convert the summary statistics file into the LD score regression format (only uses HapMap3 SNPs with MAF>5%) using their provided munge_sumstats.py script.

Include the options that are relevant for your data. For all the options type in python2 munge_sumstats.py --help

An example (summary statistics file name: MySumStatsFile.txt.gz) below is for a study with 1000 cases and 1000 controls, 
where the effect size in the file is in the column called OR, where OR=1 is no effect. The column called p.value is the p value. 
The column called A1 is the effect allele, and the column called A2 is the non-effect allele. 
Note: if the summary statistics file does not have a signed summary statistic, but A1 is always the trait- or risk-increasing allele, use the --a1-inc1 flag.

``` python2 munge_sumstats.py --chunksize 100000 --sumstats MySumStatsFile.txt.gz --merge-alleles w_hm3.snplist --snp RSID --N-cas 1000 --N-con 1000 --p p.value --signed-sumstats OR,1 --a1 A1 --a2 A2 --out PrefixForMyOutput```

This will create 2 files: 
`PrefixForMyOutput.sumstats.gz`, which is the file that you will use in all subsequent LD score analyses
`PrefixForMyOutput.log`, which lists the command and all the processing steps conducted to create the sumstats.gz file.

#### Step #2: 
Compute heritability (and LD score regression intercept). Note this is using LD scores pre-computed using 1000Genomes, EUR population.

```
python2 ldsc.py \
--h2 PrefixForMyOutput.sumstats.gz \
--ref-ld-chr eur_w_ld_chr/ \
--w-ld-chr eur_w_ld_chr/ \
--out Disease_h2
```

Check the log file `Disease_h2.log`. Near the bottom you will see `Intercept` (i.e. the LD score regression intercept) and there is also `Lambda GC` for comparison.
The heritability is listed on the observed scale. To convert the heritability to the liability scale you need the prevalence of the trait in the sample as well as in population.

#### Step #3: 
Compute genetic correlation between two traits.

```
python2 ldsc.py \
--rg PrefixForTrait1.sumstats.gz,PrefixForTrait2.sumstats.gz \
--ref-ld-chr eur_w_ld_chr/ \
--w-ld-chr eur_w_ld_chr/ \
--out Trait1_Trait2_rg
```
