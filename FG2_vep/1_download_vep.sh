#!/bin/bash
#SBATCH --job-name=queryVEPCache
#SBATCH --partition=mrcieu,compute
#SBATCH --mem=80G
#SBATCH --time=7-00:00:00
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG2_vep
#SBATCH --account=sscm013903

# Install modules and packages
./module_dependencies.sh

# Download and install VEP
git clone https://github.com/Ensembl/ensembl-vep
cd ensembl-vep
perl INSTALL.pl -a acf -s homo_sapiens -y GRCh38

# After installation, download the GRCh38 genome cache
./vep -a acf -s homo_sapiens -y GRCh38 --cache_version 104 --cache -dir_cache /path/to/cache/directory

