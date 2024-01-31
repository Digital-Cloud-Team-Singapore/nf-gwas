#!/bin/bash

num_pheno_files=10
WORKFLOW_ID="3062567"
# RUNGROUP_ID can be "" to start individual runs
RUNGROUP_ID="5650856"
S3_OUTPUT_URI="s3://precise-nf-gwas/output/big_runs/"
DATA_AWS_FOLDER="s3://precise-nf-gwas/big_data"
RSIDS_AWS_URI="s3://precise-nf-gwas/test_data/test_gwas_additive_chunking/rsids.tsv.gz"
# note: also need rsids.tsv.gz.tbi (generated with tabix) in same folder as rsids.tsv.gz

# cd to under healthomics/
cd ..

for ((i = 0 ; i < $num_pheno_files ; i++));
do
    # note: this could have multiple columns in other cases
    PHENOTYPES_COLUMNS=$((i+1))
    RUN_PARAMS_JSON_PATH="parameter_files/params_big_skip_preds_${i}.json"
    RUN_NAME="big_skip_preds_${i}"

    # write parmas json
    echo "{
        \"project\": \"${RUN_NAME}\",
        \"genotypes_association\" : \"${DATA_AWS_FOLDER}/example_big.vcf.gz\",
        \"genotypes_build\": \"hg19\",
        \"genotypes_association_format\": \"vcf\",
        \"phenotypes_filename\": \"${DATA_AWS_FOLDER}/phenotype_big_${i}.txt\",
        \"phenotypes_binary_trait\": false,
        \"phenotypes_columns\" : \"Y${PHENOTYPES_COLUMNS}\",
        \"regenie_test\": \"additive\",
        \"rsids_filename\": \"${RSIDS_AWS_URI}\",
        \"regenie_skip_predictions\": true
    }" > ${RUN_PARAMS_JSON_PATH}

    # launch runs
    if [ -z "${RUNGROUP_ID}" ]; then
        echo "Run group ID not provided, starting individual run"
        RUN_ID=$(aws omics start-run \
            --name ${RUN_NAME} \
            --workflow-id ${WORKFLOW_ID} \
            --parameters file://${RUN_PARAMS_JSON_PATH} \
            --output-uri ${S3_OUTPUT_URI} \
            --role-arn arn:aws:iam::549164395270:role/omics_start_run_role_v1 \
            | jq -r '.id')
    else
        echo "Run group ID provided: ${RUNGROUP_ID}"
        RUN_ID=$(aws omics start-run \
            --name ${RUN_NAME} \
            --workflow-id ${WORKFLOW_ID} \
            --run-group-id ${RUNGROUP_ID} \
            --parameters file://${RUN_PARAMS_JSON_PATH} \
            --output-uri ${S3_OUTPUT_URI} \
            --role-arn arn:aws:iam::549164395270:role/omics_start_run_role_v1 \
            | jq -r '.id')
    fi
        
    # check status of run
    if [ -z "${RUN_ID}" ]; then
        echo "Trigger run fail!"
        exit 1
    fi
    echo "Trigger run success, run ID: ${RUN_ID}"

    # FOR TESTING, ONLY RUN 1 RUN FIRST
    echo "exiting after starting 1 run, for testing only..."
    exit 0
done
