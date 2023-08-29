#!/bin/bash

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

# Set input and output directories
variantDir="$1"
variantFile="$2"
outputDir="$3"

# Run VEP query script
sbatch query_vep.sh "${variantDir}${variantFile}" "${outputDir}"

