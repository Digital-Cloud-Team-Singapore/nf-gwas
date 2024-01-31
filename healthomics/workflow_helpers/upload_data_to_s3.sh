#!/bin/bash
# run this within the python_helpers folder

# args
num_pheno_files=10
AWS_DEST_FOLDER="s3://precise-nf-gwas/big_data/"

# cd back to under healthomics/, where ./data/ resides
cd ..

# upload phenotype files, 1 file could have 1 or more columns
# 1 column = 1 phenotype, 1 row = 1 individual
for ((i = 0 ; i < $num_pheno_files ; i++));
do
    aws s3 cp ./data/phenotype_big_${i}.txt s3://precise-nf-gwas/big_data/
done

# make the gz, keep original file
gzip -f -k ./data/example_big.vcf

# upload VCF containing SNP variant data for all individuals per chromosome locus
aws s3 cp ./data/example_big.vcf.gz s3://precise-nf-gwas/big_data/
