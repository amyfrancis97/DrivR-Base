#!/bin/bash
#SBATCH --job-name=getVEPCache
#SBATCH --partition=gpu
#SBATCH --mem=50G
#SBATCH --time=1-00:00:0
#SBATCH --chdir=$1
#SBATCH --account=sscm013903

# Load necessary modules
module load apps/bayestraits apps/bcftools apps/samtools apps/tabix lib/htslib

# Install required Perl modules
curl -L https://cpanmin.us | perl - App::cpanminus
cpanm Archive::Zip
cpanm DBD::mysql

# Download and install VEP
git clone https://github.com/Ensembl/ensembl-vep
cd ensembl-vep
perl INSTALL.pl -a acf -s homo_sapiens -y GRCh38

# After installation, download the GRCh38 genome cache
./vep -a acf -s homo_sapiens -y GRCh38 --cache_version 104 --cache -dir_cache /path/to/cache/directory

# Optionally, remove unnecessary files
#rm -rf ensembl-vep

