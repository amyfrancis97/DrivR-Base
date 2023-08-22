#!/bin/bash
#SBATCH --job-name=getDinucleotideProperties
#SBATCH --partition=mrcieu,short,test,compute,gpu
#SBATCH --mem=250G
#SBATCH --time=3-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG3_dinucleotide_properties
#SBATCH --account=sscm013903
##SBATCH --array=1-22

# Download dinucleotide property table from https://diprodb.fli-leibniz.de/ShowTable.php
# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

Rscript dinucleotide_properties.R $1 $2 $3
