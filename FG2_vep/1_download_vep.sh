#!/bin/bash

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

# Download and install VEP
git clone https://github.com/Ensembl/ensembl-vep
cd ensembl-vep
perl INSTALL.pl -a acf -s homo_sapiens -y GRCh38


