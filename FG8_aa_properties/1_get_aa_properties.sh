#!/bin/bash

dir=$1

# specify renv location
source config.sh

# Activate the renv environment in which to run the Rscript
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"

Rscript extract_aa_properties.R ${dir[@]}
