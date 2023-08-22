#!/bin/bash
#SBATCH --job-name=queryVEPCache
#SBATCH --partition=mrcieu,short,compute
#SBATCH --mem=50G
#SBATCH --time=6-00:00:00
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG2_vep
#SBATCH --account=sscm013903

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

# relocate to where the cache was downloaded
cd ${vep_cache}ensembl-vep

# Set input variables
file="$1"
newDir="$2"

# Uncomment and modify the following commands according to your needs
# Query VEP cache for all variant effect output
./vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --protein --uniprot -o "${newDir[@]}$(basename "$file")_variant_effect_output_all.txt" --no_html

# Query VEP cache for consequence features
./vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --fields "Consequence" -o "${newDir[@]}$(basename "$file")_variant_effect_output_conseq.txt" --no_html

# Query VEP cache for AA features
./vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --fields "Amino_acids" -o "${newDir[@]}$(basename "$file")_variant_effect_output_AA.txt" --no_html

# Query VEP cache for distance features
./vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --fields "DISTANCE" -o "${newDir[@]}$(basename "$file")_variant_effect_output_distance.txt" --no_html


