#!/bin/bash
# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

# Print input arguments
echo "Input files: ${1}${2}"
basename="${2%.bed}"

# Reformatting step
cat "${1}${2}" | awk '{print $1"\t"$2-1"\t"$2"\t"$4"\t"$5"\t"$6"\t"$7}' | bedtools sort -i > "${3}${basename}.reformatted.bed"

# Perform additional checks
python check_formatting.py "${3}${basename}.reformatted.bed" "${3}${basename}.reformatted.sorted.bed"
rm "${3}${basename}.reformatted.bed"
