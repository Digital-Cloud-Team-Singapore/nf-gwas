#!/bin/bash

# would cost max $60
RUNGROUP_ID=$(aws omics create-run-group \
    --name RunGroupEthnicity \
    --max-cpus 500 \
    --max-duration 6000 \
    | jq -r '.id')

echo "Run group ID: ${RUNGROUP_ID}"
# 5650856