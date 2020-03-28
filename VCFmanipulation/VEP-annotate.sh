chrom=$1 #1-22,X
path_to_data=$2 #/net/my_data/loftee_data/

bcftools annotate -x INFO/ANN sites-chr${chrom}.bcf | vep --format vcf --cache --offline --vcf --compress_output bgzip --no_stats --allele_number --buffer_size 50000 \
--plugin LoF,loftee_path:${path_to_data}loftee,human_ancestor_fa:${path_to_data}human_ancestor.fa.gz,conservation_file:${path_to_data}loftee.sql,gerp_bigwig:${path_to_data}gerp_conservation_scores.homo_sapiens.GRCh38.bw 
--dir_plugins loftee -o sites-chr${chrom}-vep.bcf
