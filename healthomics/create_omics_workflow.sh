#!/bin/bash

# run this from repo root
# example command:
# bash ./healthomics/create_omics_workflow.sh \
#   gwas_gene_based_test \
#   precise-nf-gwas \
#   file://healthomics/parameter_files/params_template_gene_based_test.json

# user args from CLI (or modify this file)
# WORKFLOW_NAME=$1
# S3_BUCKET=$2
# PARAM_TEMPLATE=$3
WORKFLOW_NAME="gwas_gene_based_test"
S3_BUCKET="precise-nf-gwas"
PARAM_TEMPLATE="file://healthomics/parameter_files/params_template_gene_based_test.json"

# verify user args
echo "Creating workflow ${WORKFLOW_NAME}"
echo "S3 bucket URI: ${S3_BUCKET}"
echo "Parameter template JSON path: ${PARAM_TEMPLATE}"
echo "${WORKFLOW_NAME}.zip"
echo "s3://${S3_BUCKET}/workflows/${WORKFLOW_NAME}.zip"

# zip folder, exclude the folder healthomics/ as it doesnt have nextflow code
cd ..
# zip -r ${WORKFLOW_NAME}.zip nf-gwas/ -x "healthomics/*" > /dev/null

# upload workflow code to S3 bucket
aws s3 cp ${WORKFLOW_NAME}.zip s3://${S3_BUCKET}/workflows/${WORKFLOW_NAME}.zip

# create workflow
cd nf-gwas/
WORKFLOW_ID=$(aws omics create-workflow \
    --name ${WORKFLOW_NAME} \
    --definition-uri s3://${S3_BUCKET}/workflows/${WORKFLOW_NAME}.zip \
    --parameter-template ${PARAM_TEMPLATE} \
    --engine NEXTFLOW | jq -r '.id')

# verify workflow was created
echo "created workflow with id: ${WORKFLOW_ID}"
echo "checking workflow status..."
echo $(aws omics list-workflows --name ${WORKFLOW_NAME})
