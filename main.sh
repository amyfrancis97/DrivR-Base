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
#sbatch FG1_conservation/3_query_cons_features.sh $variantDir $variantFileName $variantDir

# FG2: Get VEP features - DONE
#sbatch FG2_vep/1_download_vep.sh ${scriptDir}FG2_vep
#sbatch  FG2_vep/2_query_vep.sh $variantDir $variantFileName $outputDir 
#sbatch FG2_vep/3_reformat_vep_res.sh $variantDir $variantFileName $outputDir

# FG3: Get dinucleotide properties - DONE
#sbatch FG3_dinucleotide_properties/1_get_dinuc_properties.sh $variantDir $variantFileName $outputDir

# FG4: Get dna shapes -DONE
#sbatch FG4_dna_shape/1_get_dna_shape.sh  $variantDir $variantFileName $outputDir

# FG5: Get gc & CpG - DONE
#sbatch FG5_gc_CpG/1_get_gc_CpG.sh $variantDir $variantFileName $outputDir

# FG6: Get kernels - DONE
sbatch FG6_kernel/1_get_kernel.sh $variantDir $variantFileName $outputDir

# FG7: Get aa substitution matrices - DONE
#sbatch FG7_aa_substitution_matrices/1_get_aa_matrices.sh $outputDir

# FG8: Get amino acid properties - DONE
#sbatch FG8_aa_properties/1_get_aa_properties.sh $outputDir 

# FG10: Get alpha fold scores -DONE but may need to change sleep time depending on query size
#tail -n +6 ${variantDir}${variantFileName}_variant_effect_output_all.txt > ${variantDir}${variantFileName}_variant_effect_output_all.bed
#sbatch FG10_alpha_fold/get_alpha_fold_scores_struct_conform.sh $outputDir $variantFileName
#sbatch FG10_alpha_fold/get_alpha_fold_scores_atom.sh $outputDir $variantFileName
