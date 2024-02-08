#!/bin/bash
# Load required modules
source config.sh

start=$(date +%s)

# Print input arguments
echo "Input files: ${1}${2}"
basename="${2%.bed}"

inputDir="${1}"
file="$2"
outputDir="${3}"

mkdir -p "$outputDir"

# Reformatting step
cat "${inputDir}${file}" | awk '{print $1"\t"$2-1"\t"$2"\t"$4"\t"$5}' | bedtools sort -i > "${outputDir}${basename}.reformatted.bed"

# Perform additional checks
python check_formatting.py "${outputDir}${basename}.reformatted.bed" "${outputDir}${basename}.reformatted.sorted.bed"

wait 

python get_conservation.py "${outputDir}${basename}.reformatted.sorted.bed" "${outputDir}" 
