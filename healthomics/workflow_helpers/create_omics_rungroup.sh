#!/bin/bash

RUNGROUP_ID=$(aws omics create-run-group \
    --name BigRunGroupV1 \
    --max-cpus 200 \
    --max-duration 6000 \
    | jq -r '.id')

echo "Run group ID: ${RUNGROUP_ID}"
# 5650856