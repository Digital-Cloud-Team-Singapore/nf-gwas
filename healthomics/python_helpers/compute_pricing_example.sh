#!/bin/bash

# below run had 500 variants for a single phenotype (non-binary)
python3 compute_pricing.py 2567603 --region ap-southeast-1

# should get the below:
# {
#     "info": {
#         "runId": "2567603",
#         "name": "nf_gwas_skipped_predictions_v5_test",
#         "workflowId": "6344418"
#     },
#     "total": 0.3962745659400001,
#     "cost_detail": {
#         "storage_cost": {
#             "run_duration_hr": 1.3477640833333335,
#             "storage_gib": 1200,
#             "usd_per_hour": 0.0002301,
#             "cost": 0.3721446186900001
#         },
#         "total_task_cost": 0.02412994725,
#         "task_costs": [
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:REPORTING:REPORT_INDEX",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 1,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.010029999999999999,
#                 "instance": "omics.c.large",
#                 "usd_per_hour": 0.1323,
#                 "cost": 0.001326969
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:REPORTING:REPORT (2)",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 8,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.009863888888888889,
#                 "instance": "omics.m.large",
#                 "usd_per_hour": 0.162,
#                 "cost": 0.00159795
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:REPORTING:REPORT (1)",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 8,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.010278333333333334,
#                 "instance": "omics.m.large",
#                 "usd_per_hour": 0.162,
#                 "cost": 0.0016650900000000001
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:FILTER_RESULTS (Y2)",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 1,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.010064444444444444,
#                 "instance": "omics.c.large",
#                 "usd_per_hour": 0.1323,
#                 "cost": 0.001331526
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:FILTER_RESULTS (Y1)",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 1,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.010053333333333333,
#                 "instance": "omics.c.large",
#                 "usd_per_hour": 0.1323,
#                 "cost": 0.0013300559999999998
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:MERGE_RESULTS (Y2)",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 1,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.010301666666666666,
#                 "instance": "omics.c.large",
#                 "usd_per_hour": 0.1323,
#                 "cost": 0.0013629105
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:MERGE_RESULTS (Y1)",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 1,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.010098333333333332,
#                 "instance": "omics.c.large",
#                 "usd_per_hour": 0.1323,
#                 "cost": 0.0013360095
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:ANNOTATION:ANNOTATE_RESULTS (1)",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 1,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.009776944444444446,
#                 "instance": "omics.c.large",
#                 "usd_per_hour": 0.1323,
#                 "cost": 0.0012934897500000001
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:REGENIE:REGENIE_STEP2:REGENIE_LOG_PARSER_STEP2",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 1,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.009429166666666667,
#                 "instance": "omics.c.large",
#                 "usd_per_hour": 0.1323,
#                 "cost": 0.00124747875
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:REGENIE:REGENIE_STEP2:REGENIE_STEP2_RUN (example)",
#                 "resources": {
#                     "cpus": 8,
#                     "memory_gib": 8,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.009453333333333333,
#                 "instance": "omics.c.2xlarge",
#                 "usd_per_hour": 0.5292,
#                 "cost": 0.005002703999999999
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:IMPUTED_TO_PLINK2 (1)",
#                 "resources": {
#                     "cpus": 8,
#                     "memory_gib": 16,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.010044722222222222,
#                 "instance": "omics.c.2xlarge",
#                 "usd_per_hour": 0.5292,
#                 "cost": 0.0053156670000000005
#             },
#             {
#                 "name": "NF_GWAS:SINGLE_VARIANT_TESTS:INPUT_VALIDATION:VALIDATE_PHENOTYPES",
#                 "resources": {
#                     "cpus": 1,
#                     "memory_gib": 1,
#                     "gpus": 0
#                 },
#                 "duration_hr": 0.009978055555555556,
#                 "instance": "omics.c.large",
#                 "usd_per_hour": 0.1323,
#                 "cost": 0.00132009675
#             }
#         ]
#     }
# }