cd /Users/minhtoo.lin/repos/nf-gwas/healthomics/data

~/plink2_bin/plink2 \
    --bfile example_big \
    --maf 0.01 \
    --mac 100 \
    --geno 0.1 \
    --hwe 1e-350 \
    --mind 0.1 \
    --write-snplist \
    --write-samples \
    --no-id-header \
    --out example_big_test_filtered.qc \
    --make-bed \
    --threads 8 \
    --memory 8000