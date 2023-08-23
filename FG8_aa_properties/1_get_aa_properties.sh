#!/bin/bash
#SBATCH --job-name=getAAproperties
#SBATCH --partition=compute,test,short,mrcieu
#SBATCH --mem=80G
#SBATCH --time=4-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG8_aa_properties
#SBATCH --account=sscm013903

dir=$1

# Activate the renv environment in which to run the Rscript
RENVCMD="/user/home/uw20204/DrivR-Base/FG8_aa_properties -e 'renv::activate(\"/user/home/uw20204/renv.lock\")'"

Rscript extract_aa_properties.R ${dir[@]}
