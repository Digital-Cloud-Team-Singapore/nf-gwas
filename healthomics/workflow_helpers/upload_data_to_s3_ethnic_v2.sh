#!/bin/bash
# run this within the python_helpers folder

# args
num_pheno_files=1
AWS_DEST_FOLDER="s3://precise-nf-gwas/ethnic_data_v2/"

# cd back to under healthomics/, where ./data/ethnic_data_v2/ resides
cd ..

bgzip -f -k --threads 10 -l 4 ./data/ethnic_data_v2/100002_variants_60000_samples_21_chromosomes_chinese_ethnicity.vcf
bgzip -f -k --threads 10 -l 4 ./data/ethnic_data_v2/100002_variants_10000_samples_21_chromosomes_others_ethnicity.vcf
bgzip -f -k --threads 10 -l 4 ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_malay_ethnicity.vcf
bgzip -f -k --threads 10 -l 4 ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_indian_ethnicity.vcf
echo "bgzip done"

# upload VCF containing SNP variant data for all individuals per chromosome locus
aws s3 cp ./data/ethnic_data_v2/100002_variants_60000_samples_21_chromosomes_chinese_ethnicity.vcf.gz s3://precise-nf-gwas/ethnic_data_v2/
aws s3 cp ./data/ethnic_data_v2/100002_variants_10000_samples_21_chromosomes_others_ethnicity.vcf.gz s3://precise-nf-gwas/ethnic_data_v2/
aws s3 cp ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_malay_ethnicity.vcf.gz s3://precise-nf-gwas/ethnic_data_v2/
aws s3 cp ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_indian_ethnicity.vcf.gz s3://precise-nf-gwas/ethnic_data_v2/

# make the gz for rsids too
bgzip -f -k --threads 10 -l 4 ./data/ethnic_data_v2/rsids_100002_variants_21_chromosomes.tsv
# upload rsids file
aws s3 cp ./data/ethnic_data_v2/rsids_100002_variants_21_chromosomes.tsv.gz s3://precise-nf-gwas/ethnic_data_v2/

# make tabix index for rsids file
tabix -f -s 1 -b 2 -e 2 -S 1 ./data/ethnic_data_v2/rsids_100002_variants_21_chromosomes.tsv.gz
# upload tabix index
aws s3 cp ./data/ethnic_data_v2/rsids_100002_variants_21_chromosomes.tsv.gz.tbi s3://precise-nf-gwas/ethnic_data_v2/

# make .bed / .bim / .fam files with plink2
~/plink2_bin/plink2 --vcf ./data/ethnic_data_v2/100002_variants_60000_samples_21_chromosomes_chinese_ethnicity.vcf.gz --make-bed --out ./data/ethnic_data_v2/100002_variants_60000_samples_21_chromosomes_chinese_ethnicity
~/plink2_bin/plink2 --vcf ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_indian_ethnicity.vcf.gz --make-bed --out ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_indian_ethnicity
~/plink2_bin/plink2 --vcf ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_malay_ethnicity.vcf.gz --make-bed --out ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_malay_ethnicity
~/plink2_bin/plink2 --vcf ./data/ethnic_data_v2/100002_variants_10000_samples_21_chromosomes_others_ethnicity.vcf.gz --make-bed --out ./data/ethnic_data_v2/100002_variants_10000_samples_21_chromosomes_others_ethnicity
# override .fam file with our own generated one
cp ./data/ethnic_data/60000_samples_chinese_ethnicity.fam ./data/ethnic_data_v2/100002_variants_60000_samples_21_chromosomes_chinese_ethnicity.fam
cp ./data/ethnic_data/15000_samples_indian_ethnicity.fam ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_indian_ethnicity.fam
cp ./data/ethnic_data/15000_samples_malay_ethnicity.fam ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_malay_ethnicity.fam
cp ./data/ethnic_data/10000_samples_others_ethnicity.fam ./data/ethnic_data_v2/100002_variants_10000_samples_21_chromosomes_others_ethnicity.fam
# upload
for ext in bed bim fam; do
    aws s3 cp ./data/ethnic_data_v2/100002_variants_60000_samples_21_chromosomes_chinese_ethnicity.${ext} s3://precise-nf-gwas/ethnic_data_v2/
    aws s3 cp ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_indian_ethnicity.${ext} s3://precise-nf-gwas/ethnic_data_v2/
    aws s3 cp ./data/ethnic_data_v2/100002_variants_15000_samples_21_chromosomes_malay_ethnicity.${ext} s3://precise-nf-gwas/ethnic_data_v2/
    aws s3 cp ./data/ethnic_data_v2/100002_variants_10000_samples_21_chromosomes_others_ethnicity.${ext} s3://precise-nf-gwas/ethnic_data_v2/
done
