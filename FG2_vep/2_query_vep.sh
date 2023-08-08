#!/bin/bash
#SBATCH --job-name=queryVEPCache
#SBATCH --partition=mrcieu,compute
#SBATCH --mem=80G
#SBATCH --time=7-00:00:00
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG2_vep
#SBATCH --account=sscm013903

# Install modules and packages
./module_dependencies.sh

# After installation, download the GRCh38 genome cache
./vep -a acf -s homo_sapiens -y GRCh38 --cache_version 104 --cache -dir_cache /path/to/cache/directory

# Set input and output directories
variantDir="$1"
variantFile="$2"
outputDir="$3"

# Run VEP query script
sbatch query_vep.sh "${variantDir}${variantFile}" "${outputDir}"

