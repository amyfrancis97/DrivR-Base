#!/bin/bash

# Default value for running encode
run_encode=false

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --encode) run_encode="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Load the example data
variantDir="/opt/vep/.vep/example/"
outputDir=${variantDir}features/

# Create a new directory to store the features
mkdir -p $outputDir

variants="variants_with_driver_stat.bed"

# Creates a new file without the driver status for analysis
variantFileName="${variants/_with_driver_stat/}"

cd $variantDir
cat $variants | awk '{print $1"\t"$2"\t"$2"\t"$3"\t"$4}' > $variantFileName

# Run FG1 conservation script
# This script queries phyloP & PhastCons scores
cd /opt/vep/.vep/FG1_conservation
./get_conservation.sh "$variantDir" "$variantFileName" "$outputDir"

wait 

# Run FG2 VEP script
# This script queries the VEP cache file, and extracts consequences, distances to transcripts, and amino acids
cd /opt/vep/.vep/FG2_vep
./get_vep.sh "$variantDir" "$variantFileName" "$outputDir"

wait

# Run FG3 dinucleotide properties script
# This script uses the dinucleotide property table in /FG3_dinucleotide_properties
# Extracts properties for 4 dinucleotide positions (WT {n-1, n}, WT {n, n + 1}, Mutant {n-1, n}, WT {n, n + 1})
cd /opt/vep/.vep/
Rscript /opt/vep/.vep/FG3_dinucleotide_properties/dinucleotide_properties.R "$variantDir" "$variantFileName" "$outputDir"

wait

# Run FG4 DNA shape script
# Uses R packages to extract dna shape properties for flanking nucleotide sequences
cd /opt/vep/.vep/ # navigate to home directory where renv is located
Rscript /opt/vep/.vep/FG4_dna_shape/dna_shape.R "$variantDir" "$variantFileName" "$outputDir"

wait

# Run FG5 GC content script
# This script calculates GC content and CpG islands for different window sizes flanking the variant
cd /opt/vep/.vep/FG5_gc_CpG
gunzip hg38_seq.fa.gz
python get_gc_CpG.py "$variantDir" "$variantFileName" "$outputDir"
wait

# Run FG6 kernel script
# This script calculates sequence similarity between wild type and mutant sequences based on p-spectrum kernels
cd /opt/vep/.vep/FG6_kernel
python get_kernel.py "$variantDir" "$variantFileName" "$outputDir"

wait

# Run FG7 amino acid substitution matrices script
# This script queries a selection of amino acid substitution matrices to derive amino acid conservation scores
# First argument is output dir as it uses the output from VEP
cd /opt/vep/.vep/ # navigate to home directory where renv is located
Rscript /opt/vep/.vep/FG7_aa_substitution_matrices/aa_subs_matrices.R "$outputDir" "$variantFileName" "$outputDir"

wait

# Run FG8 amino acid property script
# This script extracts amino acid properties for the predicted wild type and mutant amino acids
# First argument is output dir as it uses the output from VEP
cd /opt/vep/.vep/ # navigate to home directory where renv is located
Rscript /opt/vep/.vep/FG8_aa_properties/extract_aa_properties.R "$outputDir" "$variantFileName" "$outputDir"

wait

# Conditional execution of FG9 section based on the run_encode flag
if [[ "$run_encode" == "true" ]]; then
    cd /opt/vep/.vep/FG9_encode
    ./download_encode.sh "$variantDir" "$variantFileName" "$outputDir"
    ./intersect_encode.sh "$variantDir" "$variantFileName" "$outputDir"
    wait
fi

# Run FG10 Alpha Fold script
# This script queries the downloaded alpha fold cif files to etract information about the structural features at the coding positions
cd /opt/vep/.vep/FG10_alpha_fold
chmod +x download_cif.sh
./download_cif.sh

wait

cd /opt/vep/.vep/FG10_alpha_fold
python get_alpha_fold.py "$outputDir" "$variantFileName" "$outputDir"

# Merge all of the feature files
cd /opt/vep/.vep/
chmod +x merge_features.sh
./merge_features.sh

mv ${outputDir}all_features.bed ${outputDir}all_features.tmp

wait

# Delete the individual feature files to free up space
rm ${outputDir}*.bed
rm ${outputDir}*.txt
rm ${outputDir}*.csv
rm ${outputDir}*.bedGraph

wait 

mv ${outputDir}all_features.tmp ${outputDir}all_features.bed
