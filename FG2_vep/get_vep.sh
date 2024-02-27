#!/bin/bash
start=$(date +%s)

source config.sh

# Set location of vep cache
cd $vep_cache

# Set input and output directories
variantDir="$1"
variantFile="$2"
outputDir="$3"

# relocate to where the cache was downloaded
#cd ${vep_cache}ensembl-vep

# Set input variables
file="${variantDir}${variantFile}"

bedtools sort -i $file > ${file}.sorted.bed
mv ${file}.sorted.bed $file

# Query VEP cache for all variant effect output
vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --protein --uniprot -o "${outputDir[@]}$(basename "$file")_variant_effect_output_all.txt" --no_stats

wait

# Query VEP cache for consequence features
vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --fields "Consequence" -o "${outputDir[@]}$(basename "$file")_variant_effect_output_conseq.txt" --no_stats

wait 

# Query VEP cache for AA features
vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --fields "Amino_acids" -o "${outputDir[@]}$(basename "$file")_variant_effect_output_AA.txt" --no_stats

wait 

# Query VEP cache for distance features
vep -i "${file[@]}" --fork 4 --offline --cache --force_overwrite --vcf --fields "DISTANCE" -o "${outputDir[@]}$(basename "$file")_variant_effect_output_distance.txt" --no_stats

wait 

tail -n +5 "${outputDir[@]}$(basename "$file")_variant_effect_output_distance.txt" > "${outputDir[@]}$(basename "$file")_variant_effect_output_distance.txt".tmp
mv "${outputDir[@]}$(basename "$file")_variant_effect_output_distance.txt".tmp  "${outputDir[@]}$(basename "$file")_variant_effect_output_distance.txt"

tail -n +5 "${outputDir[@]}$(basename "$file")_variant_effect_output_AA.txt" > "${outputDir[@]}$(basename "$file")_variant_effect_output_AA.txt".tmp
mv "${outputDir[@]}$(basename "$file")_variant_effect_output_AA.txt".tmp "${outputDir[@]}$(basename "$file")_variant_effect_output_AA.txt"

tail -n +5 "${outputDir[@]}$(basename "$file")_variant_effect_output_conseq.txt" > "${outputDir[@]}$(basename "$file")_variant_effect_output_conseq.txt".tmp
mv "${outputDir[@]}$(basename "$file")_variant_effect_output_conseq.txt".tmp "${outputDir[@]}$(basename "$file")_variant_effect_output_conseq.txt"

wait 

vep_output=("conseq" "distance" "aa")
for i in ${vep_output[@]}; do
# Run Python script for reformatting VEP output
python ${working_dir}reformat_vep_${i}.py  "${outputDir}" "${outputDir[@]}$(basename "$file")_";
done

wait

# Delete the original vep output files
rm -rf  "${outputDir[@]}$(basename "$file")_variant_effect_output_distance.txt" "${outputDir[@]}$(basename "$file")_variant_effect_output_AA.txt" "${outputDir[@]}$(basename "$file")_variant_effect_output_conseq.txt"

end=$(date +%s)
echo "Elapsed Time: $(($end-$start)) seconds"
