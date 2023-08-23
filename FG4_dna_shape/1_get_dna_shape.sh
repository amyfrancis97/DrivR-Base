#!/bin/bash
#SBATCH --job-name=getDNAShape
#SBATCH --partition=short,test,compute,mrcieu,gpu
#SBATCH --mem=80G
#SBATCH --time=3-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG4_dna_shape
#SBATCH --account=sscm013903

# Activate the renv environment in which to run the Rscript
RENVCMD="/user/home/uw20204/DrivR-Base/FG4_dna_shape -e 'renv::activate(\"/user/home/uw20204/renv.lock\")'"

Rscript dna_shape.R $1 $2 $3
