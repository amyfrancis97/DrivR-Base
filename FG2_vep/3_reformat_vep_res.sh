#!/bin/bash

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

# Set input and output directories
variantDir="$1"
variantFile="$2"
outputDir="$3"

vep_output=("conseq" "distance" "aa")
for i in ${vep_output[@]}; do
echo $i
sbatch reformat_vep.sh "${variantDir}${variantFile}" "${outputDir}" "${i}";
done

wait 

