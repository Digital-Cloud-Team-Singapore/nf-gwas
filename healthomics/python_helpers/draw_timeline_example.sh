#!/bin/bash

# -u is time units, sec or min or hr or day
# 1 million variants x 50k samples, quantitative phenotype
# 33 cents, 125 mins
python3 timeline.py 4414369 --region ap-southeast-1 -u min

# $1.09 for chinese. 100 phenotypes. 60k samples. 100k variants total. 21 chromosomes.
# 88 million variants --> $1.09 x 880 = $959.20
# scaling of price per phenotype is uncertain. it's sub-linear (N phenotypes doesn't mean Nx price, but it's less than Nx)