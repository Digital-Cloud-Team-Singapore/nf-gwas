#!/bin/bash
# run this within the python_helpers folder

# args
num_pheno_files=1
AWS_DEST_FOLDER="s3://precise-nf-gwas/ethnic_data/"

# cd back to under healthomics/, where ./data/ethnic_data/ resides
cd ..

# upload phenotype files, 1 file could have 1 or more columns
# 1 column = 1 phenotype, 1 row = 1 individual
# for ((i = 0 ; i < $num_pheno_files ; i++)); do
#     aws s3 cp ./data/phenotype_50000_samples_10cols_${i}.txt s3://precise-nf-gwas/big_data/
# done

aws s3 cp ./data/ethnic_data/phenotype_60000_samples_100cols_chinese_ethnicity_0.txt s3://precise-nf-gwas/ethnic_data/
aws s3 cp ./data/ethnic_data/phenotype_10000_samples_100cols_others_ethnicity_0.txt s3://precise-nf-gwas/ethnic_data/
aws s3 cp ./data/ethnic_data/phenotype_15000_samples_100cols_indian_ethnicity_0.txt s3://precise-nf-gwas/ethnic_data/
aws s3 cp ./data/ethnic_data/phenotype_15000_samples_100cols_malay_ethnicity_0.txt s3://precise-nf-gwas/ethnic_data/

# bgzip is MUCH faster than gzip! gzip is single-threaded also. 
# gzip took 20 mins at default level (6, 16x comp), bgzip barely 1 min at level 2 (8x comp)
bgzip -f -k --threads 10 -l 4 ./data/ethnic_data/100000_variants_60000_samples_5_chromosomes_chinese_ethnicity.vcf
bgzip -f -k --threads 10 -l 4 ./data/ethnic_data/100000_variants_10000_samples_5_chromosomes_others_ethnicity.vcf
bgzip -f -k --threads 10 -l 4 ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_malay_ethnicity.vcf
bgzip -f -k --threads 10 -l 4 ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_indian_ethnicity.vcf

# upload VCF containing SNP variant data for all individuals per chromosome locus
aws s3 cp ./data/ethnic_data/100000_variants_60000_samples_5_chromosomes_chinese_ethnicity.vcf.gz s3://precise-nf-gwas/ethnic_data/
aws s3 cp ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_indian_ethnicity.vcf.gz s3://precise-nf-gwas/ethnic_data/
aws s3 cp ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_malay_ethnicity.vcf.gz s3://precise-nf-gwas/ethnic_data/
aws s3 cp ./data/ethnic_data/100000_variants_10000_samples_5_chromosomes_others_ethnicity.vcf.gz s3://precise-nf-gwas/ethnic_data/

# make the gz for rsids too
bgzip -f -k --threads 10 -l 4 ./data/ethnic_data/rsids_100000_variants_5_chromosomes.tsv
# upload rsids file
aws s3 cp ./data/ethnic_data/rsids_100000_variants_5_chromosomes.tsv.gz s3://precise-nf-gwas/ethnic_data/

# make tabix index for rsids file
tabix -f -s 1 -b 2 -e 2 -S 1 ./data/ethnic_data/rsids_100000_variants_5_chromosomes.tsv.gz
# upload tabix index
aws s3 cp ./data/ethnic_data/rsids_100000_variants_5_chromosomes.tsv.gz.tbi s3://precise-nf-gwas/ethnic_data/

# make .bed / .bim / .fam files with plink2
~/plink2_bin/plink2 --vcf ./data/ethnic_data/100000_variants_60000_samples_5_chromosomes_chinese_ethnicity.vcf.gz --make-bed --out ./data/ethnic_data/100000_variants_60000_samples_5_chromosomes_chinese_ethnicity
~/plink2_bin/plink2 --vcf ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_indian_ethnicity.vcf.gz --make-bed --out ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_indian_ethnicity
~/plink2_bin/plink2 --vcf ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_malay_ethnicity.vcf.gz --make-bed --out ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_malay_ethnicity
~/plink2_bin/plink2 --vcf ./data/ethnic_data/100000_variants_10000_samples_5_chromosomes_others_ethnicity.vcf.gz --make-bed --out ./data/ethnic_data/100000_variants_10000_samples_5_chromosomes_others_ethnicity
# override .fam file with our own generated one
cp ./data/ethnic_data/60000_samples_chinese_ethnicity.fam ./data/ethnic_data/100000_variants_60000_samples_5_chromosomes_chinese_ethnicity.fam
cp ./data/ethnic_data/15000_samples_indian_ethnicity.fam ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_indian_ethnicity.fam
cp ./data/ethnic_data/15000_samples_malay_ethnicity.fam ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_malay_ethnicity.fam
cp ./data/ethnic_data/10000_samples_others_ethnicity.fam ./data/ethnic_data/100000_variants_10000_samples_5_chromosomes_others_ethnicity.fam
# upload
for ext in bed bim fam; do
    aws s3 cp ./data/ethnic_data/100000_variants_60000_samples_5_chromosomes_chinese_ethnicity.${ext} s3://precise-nf-gwas/ethnic_data/
    aws s3 cp ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_indian_ethnicity.${ext} s3://precise-nf-gwas/ethnic_data/
    aws s3 cp ./data/ethnic_data/100000_variants_15000_samples_5_chromosomes_malay_ethnicity.${ext} s3://precise-nf-gwas/ethnic_data/
    aws s3 cp ./data/ethnic_data/100000_variants_10000_samples_5_chromosomes_others_ethnicity.${ext} s3://precise-nf-gwas/ethnic_data/
done
