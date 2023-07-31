#!/bin/bash
#SBATCH --job-name=getDNAShape
#SBATCH --partition=short,test,compute,mrcieu,gpu
#SBATCH --mem=80G
#SBATCH --time=3-00:00:0
#SBATCH --chdir=$4
#SBATCH --account=sscm013903

module load lang/r
Rscript dna_shape.R $1 $2 $3
