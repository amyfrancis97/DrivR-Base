#!/bin/bash
#SBATCH --job-name=getDinucleotideProperties
#SBATCH --partition=short,test,compute,mrcieu,gpu
#SBATCH --mem=250G
#SBATCH --time=3-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG3_dinucleotide_properties
#SBATCH --account=sscm013903
##SBATCH --array=1-22

# Download dinucleotide property table from https://diprodb.fli-leibniz.de/ShowTable.php
module load lang/r/4.3.0-gcc
Rscript dinucleotide_properties.R $1 $2 $3
