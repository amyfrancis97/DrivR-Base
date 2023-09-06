#!/bin/bash
#SBATCH --job-name=reformatVariants
#SBATCH --partition=test,short,compute,mrcieu
#SBATCH --mem=50G
#SBATCH --time=3-00:00:00
#SBATCH --chdir=/user/home/uw20204/DrivR-Base
#SBATCH --account=sscm013903

source ~/.bashrc

# Activate the renv environment in which to run the Rscript
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"

#variantDir="/bp1/mrcieu1/data/encode/public/"
#variantFileName="cosmicSomaMutDB.bed"
#variantFileNameReformat="cosmicSomaMutDB.reformatted.sorted.bed"
#outputDir="/bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/"
scriptDir="/user/home/uw20204/DrivR-Base/"

variantDir="/user/home/uw20204/DrivR-Base/example/"
variantFileName="variants.bed"
variantFileNameReformat="variants.reformatted.sorted.bed"
outputDir="/bp1/mrcieu1/data/encode/public/test/"

#mkdir -p $outputDir

# FG1: Get conservation features
#cd /user/home/uw20204/DrivR-Base/FG1_conservation
#./get_conservation.sh $variantDir $variantFileName $outputDir

# FG2: Get VEP features - DONE
#cd /user/home/uw20204/DrivR-Base/FG2_vep
#./get_vep.sh  $variantDir $variantFileName $outputDir

# FG3: Get dinucleotide properties - DONE
#cd /user/home/uw20204/DrivR-Base/FG3_dinucleotide_properties
#source config.sh
#Rscript dinucleotide_properties.R $variantDir $variantFileName $outputDir

# FG4: Get dna shapes -DONE
#cd /user/home/uw20204/DrivR-Base/FG4_dna_shape
#Rscript dna_shape.R $variantDir $variantFileName $outputDir

# FG5: Get gc & CpG - DONE
#cd /user/home/uw20204/DrivR-Base/FG5_gc_CpG
#python get_gc_CpG.py $variantDir $variantFileName $outputDir

# FG6: Get kernels - DONE
#cd /user/home/uw20204/DrivR-Base/FG6_kernel
#python get_kernel.py $variantDir $variantFileName $outputDir


# FG7: Get aa substitution matrices - DONE
#cd /user/home/uw20204/DrivR-Base/FG7_aa_substitution_matrices
#Rscript aa_subs_matrices.R ${outputDir}

# FG8: Get aa properties - DONE
#cd /user/home/uw20204/DrivR-Base/FG8_aa_properties
#Rscript extract_aa_properties.R ${outputDir}

# FG9: Get encode values
cd /user/home/uw20204/DrivR-Base/FG9_encode
./test.sh $variantDir $variantFileName $outputDir


# FG10: Get alpha fold scores -DONE but may need to change sleep time depending on query size
#cd /user/home/uw20204/DrivR-Base/FG10_alpha_fold
#python get_alpha_fold_atom.py $outputDir $variantFileName

#wait 

#python get_alpha_fold_struct_conf.py $outputDir $variantFileName

