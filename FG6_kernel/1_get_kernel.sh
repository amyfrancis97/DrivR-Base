#!/bin/bash
#SBATCH --job-name=get_kernel
#SBATCH --partition=short,test,compute,mrcieu,gpu
#SBATCH --mem=175G
#SBATCH --time=10-00:00:0
#SBATCH --chdir=$4
#SBATCH --account=sscm013903

python get_kernel.py $1 $2 $3
