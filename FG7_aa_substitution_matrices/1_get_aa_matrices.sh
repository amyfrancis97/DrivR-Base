#!/bin/bash
#SBATCH --job-name=getAASubMatrices
#SBATCH --partition=short,test,mrcieu,compute
#SBATCH --mem=80G
#SBATCH --time=4-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG7_aa_substitution_matrices
#SBATCH --account=sscm013903

dir=$1

# Activate the renv environment in which to run the Rscript
RENVCMD="/user/home/uw20204/DrivR-Base/FG7_aa_substitution_matrices -e 'renv::activate(\"/user/home/uw20204/renv.lock\")'"

# Separate script to get the data since sometimes bio2mds has issues being run without XQuarts 
# Rscript get_subs_matrix_table.R

# The output sub.mat data table can then be read into the next script using the source function in the packages script.
Rscript aa_subs_matrices.R ${dir[@]}
