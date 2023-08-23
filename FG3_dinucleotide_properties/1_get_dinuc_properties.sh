#!/bin/bash
#SBATCH --job-name=getDinucleotideProperties
#SBATCH --partition=mrcieu,short,test,compute,gpu
#SBATCH --mem=80G
#SBATCH --time=3-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG3_dinucleotide_properties
#SBATCH --account=sscm013903

# Activate the renv environment in which to run the Rscript
RENVCMD="/user/home/uw20204/DrivR-Base/FG3_dinucleotide_properties -e 'renv::activate(\"/user/home/uw20204/renv.lock\")'"

Rscript dinucleotide_properties.R $1 $2 $3
