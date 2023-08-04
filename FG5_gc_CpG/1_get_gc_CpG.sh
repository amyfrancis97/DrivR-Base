#!/bin/bash
#SBATCH --job-name=getGC_CpG
#SBATCH --partition=short,test,compute,mrcieu,gpu
#SBATCH --mem=80G
#SBATCH --time=01:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG5_gc_CpG
#SBATCH --account=sscm013903

python get_gc_CpG.py $1 $2 $3
