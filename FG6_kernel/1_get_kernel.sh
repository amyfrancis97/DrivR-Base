#!/bin/bash
#SBATCH --job-name=get_kernel
#SBATCH --partition=short,test,compute,mrcieu,gpu
#SBATCH --mem=80G
#SBATCH --time=10-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG6_kernel
#SBATCH --account=sscm013903

python get_kernel.py $1 $2 $3
