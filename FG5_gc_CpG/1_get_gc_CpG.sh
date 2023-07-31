#!/bin/bash
#SBATCH --job-name=getGC_CpG
#SBATCH --partition=short,test,compute,mrcieu,gpu
#SBATCH --mem=80G
#SBATCH --time=01:00:0
#SBATCH --chdir=$4
#SBATCH --account=sscm013903

python get_gc_CpG.py $1 $2 $3
