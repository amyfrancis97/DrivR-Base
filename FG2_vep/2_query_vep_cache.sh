#!/bin/bash
#SBATCH --job-name=queryVEPCache
#SBATCH --partition=mrcieu,compute
#SBATCH --mem=80G
#SBATCH --time=7-00:00:00
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG2_vep
#SBATCH --account=sscm013903

# Load required modules
module load lang/perl
cpanm Archive::Zip
cpanm DBD::mysql
module load apps/bayestraits apps/bcftools apps/samtools apps/tabix lib/htslib

# Set input and output directories
variantDir="$1"
variantFile="$2"
outputDir="$3"

# Run VEP query script
sbatch query_vep.sh "${variantDir}${variantFile}" "${outputDir}"

