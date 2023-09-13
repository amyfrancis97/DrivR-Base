#!/bin/bash

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

# Download and install VEP
git clone https://github.com/Ensembl/ensembl-vep
cd ensembl-vep
perl INSTALL.pl -a acf -s homo_sapiens -y GRCh38

# Set input and output directories
variantDir="$1"
variantFile="$2"
outputDir="$3"

# relocate to where the cache was downloaded
cd ${vep_cache}ensembl-vep

# Set input variables
file="${variantDir}${variantFile}"


# Query VEP cache for all variant effect output
./vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --protein --uniprot -o "${outputDir[@]}$(basename "$file")_variant_effect_output_all.txt" --no_stats

# Query VEP cache for consequence features
./vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --fields "Consequence" -o "${outputDir[@]}$(basename "$file")_variant_effect_output_conseq.txt" --no_stats

# Query VEP cache for AA features
./vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --fields "Amino_acids" -o "${outputDir[@]}$(basename "$file")_variant_effect_output_AA.txt" --no_stats

# Query VEP cache for distance features
./vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --fields "DISTANCE" -o "${outputDir[@]}$(basename "$file")_variant_effect_output_distance.txt" --no_stats

wait 

#vep_output=("conseq" "distance" "aa")
#for i in ${vep_output[@]}; do
# Run Python script for reformatting VEP output
#python ${working_dir}reformat_vep_${i}.py  "${outputDir}" "${outputDir[@]}$(basename "$file")_";
#done

python reformat_vep.py "${outputDir}" "${outputDir[@]}$(basename "$file")_"

wait

# Delete the original vep output files
#rm -rf  "${outputDir[@]}$(basename "$file")_variant_effect_output_distance.txt" "${outputDir[@]}$(basename "$file")_variant_effect_output_AA.txt" "${outputDir[@]}$(basename "$file")_variant_effect_output_conseq.txt"

# Delete the cache
rm -rf ${vep_cache}ensembl-vep
