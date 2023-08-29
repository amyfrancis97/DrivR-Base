#!/bin/bash
#SBATCH --job-name=getEncodeData
#SBATCH --partition=mrcieu,test,short,compute
#SBATCH --mem=80G
#SBATCH --time=1-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG9_encode
#SBATCH --account=sscm013903

srun python getENCODEdatasets.py $1 $2

#wait

#gzip ${2}${1}_results_encode_appended.txt
