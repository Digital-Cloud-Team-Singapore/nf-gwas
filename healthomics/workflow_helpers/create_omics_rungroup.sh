#!/bin/bash

# would cost max $60
RUNGROUP_ID=$(aws omics create-run-group \
    --name BigRunGroup_300mins_200cpus \
    --max-cpus 200 \
    --max-duration 300 \
    | jq -r '.id')

echo "Run group ID: ${RUNGROUP_ID}"
# 5650856