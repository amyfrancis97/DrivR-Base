#!/bin/bash

#variantDir="/bp1/mrcieu1/data/encode/public/"
#variantFileName="cosmicSomaMutDB.bed"
#variantFileNameReformat="cosmicSomaMutDB.reformatted.sorted.bed"
#outputDir="/bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/"
scriptDir="/user/home/uw20204/DrivR-Base/"

variantDir="/bp1/mrcieu1/data/encode/public/test/"
variantFileName="variants.test.bed"
variantFileNameReformat="variants.test.reformatted.sorted.bed"
outputDir="/bp1/mrcieu1/data/encode/public/test/"

#mkdir -p $outputDir

# FG1: Get conservation features
#sbatch FG1_conservation/1_reformat.sh $variantDir $variantFileName $variantDir
#sbatch FG1_conservation/2_download_cons_features.sh $variantDir $variantFileName $variantDir
#sbatch FG1_conservation/2_get_cons_features.sh $variantDir $variantFileName $variantDir

# FG2: Get VEP features
#sbatch FG2_vep/1_get_vep_cache.sh ${scriptDir}FG2_vep
#sbatch  FG2_vep/2_query_vep_cache.sh $variantDir $variantFileName $outputDir 
sbatch FG2_vep/3_reformat_vep_output.sh $variantDir $variantFileName $outputDir ${scriptDir}FG2_vep

# FG3: Get dinucleotide properties
#sbatch FG3_dinucleotide_properties/1_get_dinuc_properties.sh $variantDir $variantFileName $outputDir

# FG4: Get dna shapes
#sbatch FG4_dna_shape/1_get_dna_shape.sh  $variantDir $variantFileName $outputDir

# FG5: Get gc & CpG 
#sbatch FG5_gc_CpG/1_get_gc_CpG.sh $variantDir $variantFileName $outputDir

# FG6: Get kernels
#sbatch FG6_kernel/1_get_kernel.sh $variantDir $variantFileName $outputDir ${scriptDir}FG6_kernel

# FG7: Get aa substitution matrices
#sbatch FG7_aa_substitution_matrices/1_get_aa_matrices.sh $outputDir ${scriptDir}FG7_aa_substitution_matrices

# FG8: Get amino acid properties
#sbatch FG8_aa_properties/1_get_aa_properties.sh $outputDir ${scriptDir}FG8_aa_properties
