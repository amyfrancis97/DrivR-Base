#!/bin/bash
#SBATCH --job-name=getAAproperties
#SBATCH --partition=compute,test,short,mrcieu
#SBATCH --mem=200G
#SBATCH --time=4-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG8_aa_properties
#SBATCH --account=sscm013903

# Download dinucleotide property table from https://diprodb.fli-leibniz.de/ShowTable.php
module load lang/r

dir=$1
Rscript extract_aa_properties.R ${dir[@]}
