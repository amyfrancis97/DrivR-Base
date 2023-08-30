#!/bin/bash

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

# Set the directory for conservation files
cd $download_cons_dir

# Get all available conservation feature datasets for querying
data=(*.bedGraph)

for i in ${data[@]}; do
echo $i
# Specify input and output directories
inputDir="${1}"
outputDir="${3}"
mkdir -p "$outputDir"

# Specify variant datasets
reformattedOutput="${1}${2}"

# Find intersects between cosmic/gnomad data and conservation scores
bedtools intersect -wa -wb -a "$i" -b "$reformattedOutput" -sorted |
  awk '{print $5"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$4}' > "${outputDir}${i[6]}_cons.out.bed" &;
done
