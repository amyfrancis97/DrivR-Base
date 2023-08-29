#!/bin/bash

# specify renv location
source config.sh

# Activate the renv environment in which to run the Rscript
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"

Rscript dna_shape.R $1 $2 $3
