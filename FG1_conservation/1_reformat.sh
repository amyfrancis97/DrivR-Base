#!/bin/bash
#SBATCH --job-name=reformatVariants
#SBATCH --partition=mrcieu,compute
#SBATCH --mem=80G
#SBATCH --time=3-00:00:00
#SBATCH --chdir=$4
#SBATCH --account=sscm013903

# Load required modules
module load apps/bedtools apps/bedops

# Print input arguments
echo "Input files: ${1}${2}"
basename="${2%.bed}"

# Reformatting step
cat "${1}${2}" | awk '{print $1"\t"$2-1"\t"$2"\t"$4"\t"$5"\t"$6"\t"$7}' | bedtools sort -i > "${3}${basename}.reformatted.bed"

# Perform additional checks
python check_formatting.py "${3}${basename}.reformatted.bed" "${3}${basename}.reformatted.sorted.bed"

