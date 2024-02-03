#!/bin/bash
# run this within the python_helpers folder

# args
num_pheno_files=1
AWS_DEST_FOLDER="s3://precise-nf-gwas/big_data/"

# cd back to under healthomics/, where ./data/ resides
cd ..

# upload phenotype files, 1 file could have 1 or more columns
# 1 column = 1 phenotype, 1 row = 1 individual
for ((i = 0 ; i < $num_pheno_files ; i++));
do
    aws s3 cp ./data/phenotype_biggest_20_${i}.txt s3://precise-nf-gwas/big_data/
done

# bgzip is MUCH faster than gzip! gzip is single-threaded also. 
# gzip took 20 mins at default level (6, 16x comp), bgzip barely 1 min at level 2 (8x comp)
bgzip -f -k --threads 8 -l 6 ./data/example_bigger.vcf
# upload VCF containing SNP variant data for all individuals per chromosome locus
aws s3 cp ./data/example_bigger.vcf.gz s3://precise-nf-gwas/big_data/

# make the gz for rsids too
bgzip -f -k ./data/rsids_big.tsv
# upload rsids file
aws s3 cp ./data/rsids_big.tsv.gz s3://precise-nf-gwas/big_data/

# make tabix index for rsids file
tabix -f -s 1 -b 2 -e 2 -S 1 ./data/rsids_big.tsv.gz
# upload tabix index
aws s3 cp ./data/rsids_big.tsv.gz.tbi s3://precise-nf-gwas/big_data/

# make .bed / .bim / .fam files with plink2
~/plink2_bin/plink2 --vcf ./data/example_big.vcf.gz --make-bed --out ./data/example_big
# upload
aws s3 cp ./data/example_big.bed s3://precise-nf-gwas/big_data/
aws s3 cp ./data/example_big.bim s3://precise-nf-gwas/big_data/
aws s3 cp ./data/example_big.fam s3://precise-nf-gwas/big_data/