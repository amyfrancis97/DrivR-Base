#!/bin/bash
source ~/.bashrc

# Activate the renv environment in which to run the Rscript
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"
#
#tissue="prostate_NS"
#variantDir="/user/home/uw20204/CanDrivR_data/tissue_specific/tissue_variants/${tissue}_variants/"
#variantFileName="${tissue}_variants.bed"
#outputDir=${variantDir}features/


#variantDir="/user/home/uw20204/CanDrivR_data/tissue_specific/tissue_variants/prostate_adenocarcinoma/"
#variantFileName="prostate_adenocarcinoma_variants.bed"
#outputDir=${variantDir}features/

#variantDir="/user/home/uw20204/CanDrivR_data/test_driver_variants/"
#variantFileName="known_drivers_GrCh38_feat_ext.txt"
#outputDir=${variantDir}features/

#variantDir="/user/home/uw20204/CanDrivR_data/test_neutral_variants/"
#variantFileName="dbSNP_neutral_variants_by_ALFA.txt"
#outputDir=${variantDir}features/

variantDir="/user/home/uw20204/CanDrivR_data/test_neutral_variants/missense_and_others/"
variantFileName="neutral_variants_with_missense.bed"
outputDir=${variantDir}features/

mkdir -p $outputDir
for i in {7..10}; do
job=get_FG${i}.sh
sbatch $job $variantDir $variantFileName $variantFileNameReformat $outputDir;
done

