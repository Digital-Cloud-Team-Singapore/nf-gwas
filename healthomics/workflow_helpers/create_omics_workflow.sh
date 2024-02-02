#!/bin/bash

# NOTE: RUN FROM REPO ROOT
# bash ./healthomics/workflow_helpers/create_omics_workflow.sh

# user args to be modified
WORKFLOW_NAME="gwas_big_data_test_192cpus"
S3_BUCKET="precise-nf-gwas"
PARAM_TEMPLATE="file://healthomics/parameter_files/params_template_skipped_predictions.json"

# verify user args
echo "Creating workflow ${WORKFLOW_NAME}"
echo "S3 bucket URI: ${S3_BUCKET}"
echo "Parameter template JSON path: ${PARAM_TEMPLATE}"
echo "${WORKFLOW_NAME}.zip"
echo "s3://${S3_BUCKET}/workflows/${WORKFLOW_NAME}.zip"

# zip folder, exclude the folder healthomics/ as it doesnt have nextflow code
cd ..
zip -r ${WORKFLOW_NAME}.zip ./nf-gwas/ -x "./nf-gwas/healthomics/*" > /dev/null

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
