#!/bin/bash
#SBATCH --job-name=getGC_CpG
#SBATCH --partition=short,test,mrcieu,compute
#SBATCH --mem=150G
#SBATCH --time=1-01:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG5_gc_CpG
#SBATCH --account=sscm013903

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

python get_gc_CpG.py $1 $2 $3
