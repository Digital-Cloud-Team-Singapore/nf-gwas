#!/bin/bash

# run this from within ./workflow_helpers/

cd ..

WORKFLOW_ID="7900176"
# RUNGROUP_ID can be "" to start individual runs
RUNGROUP_ID="5650856"
RUN_PARAMS_JSON_PATH="parameter_files/params_example_additive.json"
S3_OUTPUT_URI="s3://precise-nf-gwas/output/test_bothsteps/"

# get RUN_NAME from RUN_PARAMS_JSON_PATH
RUN_NAME=$(jq -r '.project' ${RUN_PARAMS_JSON_PATH})
echo "RUN_NAME: ${RUN_NAME}"

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
