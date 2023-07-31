#!/bin/bash
#SBATCH --job-name=queryVEPCache
#SBATCH --partition=mrcieu,short,compute
#SBATCH --mem=50G
#SBATCH --time=6-00:00:00
#SBATCH --chdir=/user/home/uw20204/CanDrivR_scripts/features_v2/FG2_vep
#SBATCH --account=sscm013903

# Load required modules
cpanm Archive::Zip
cpanm DBD::mysql
module load apps/bayestraits apps/bcftools apps/samtools apps/tabix lib/htslib

# Set input variables
file="$1"
newDir="$2"
vep_output="$3"

# Run Python script for reformatting
python reformat_vep_${vep_output}.py  "${newDir}" "${newDir[@]}$(basename "$file")_"
