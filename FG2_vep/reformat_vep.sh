#!/bin/bash
#SBATCH --job-name=queryVEPCache
#SBATCH --partition=mrcieu,short,compute
#SBATCH --mem=80G
#SBATCH --time=6-00:00:00
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG2_vep
#SBATCH --account=sscm013903

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

# Set input variables
file="$1"
newDir="$2"
vep_output="$3"

# Run Python script for reformatting
python reformat_vep_${vep_output}.py  "${newDir}" "${newDir[@]}$(basename "$file")_"
