#!/bin/bash
#SBATCH --job-name=queryVEPCache
#SBATCH --partition=mrcieu,compute
#SBATCH --mem=150G
#SBATCH --time=7-00:00:00
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG2_vep
#SBATCH --account=sscm013903

# Install modules and packages
./module_dependencies.sh

# Set input and output directories
variantDir="$1"
variantFile="$2"
outputDir="$3"

vep_output=("conseq" "distance" "aa")
for i in ${vep_output[@]}; do
echo $i
sbatch reformat_vep.sh "${variantDir}${variantFile}" "${outputDir}" "${i}";
done

