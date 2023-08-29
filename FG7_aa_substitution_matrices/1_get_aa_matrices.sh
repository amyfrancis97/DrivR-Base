#!/bin/bash

dir=$1

# specify renv location
source config.sh

# Activate the renv environment in which to run the Rscript
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"

# Separate script to get the data since sometimes bio2mds has issues being run without XQuarts 
# Rscript get_subs_matrix_table.R

# The output sub.mat data table can then be read into the next script using the source function in the packages script.
Rscript aa_subs_matrices.R ${dir[@]}
