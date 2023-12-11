#!/bin/bash
source ~/.bashrc

# Activate the renv environment in which to run the Rscript
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"
#
#tissue="prostate_NS"
#variantDir="/user/home/uw20204/CanDrivR_data/tissue_specific/tissue_variants/${tissue}_variants/"
#variantFileName="${tissue}_variants.bed"
#outputDir=${variantDir}features/


variantDir="/user/home/uw20204/CanDrivR_data/tissue_specific/tissue_variants/prostate_adenocarcinoma/"
variantFileName="prostate_adenocarcinoma_variants.bed"
outputDir=${variantDir}features/

mkdir -p $outputDir
sbatch get_FG2.sh $variantDir $variantFileName $variantFileNameReformat $outputDir
#for i in {1..5}; do
#job=get_FG${i}.sh
#sbatch $job $variantDir $variantFileName $variantFileNameReformat $outputDir;
#done

