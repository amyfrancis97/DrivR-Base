#!/bin/bash
#SBATCH --job-name=getEncodeValues
#SBATCH --partition=compute
#SBATCH --mem=175G
#SBATCH --time=14-00:00:0
#SBATCH --chdir=/bp1/mrcieu1/users/uw20204/paper1/features_v2/FG9_encode
#SBATCH --account=sscm013903

# Load bedtools
module load apps/bedops/2.4.38 apps/bedtools/2.30.0
module load apps/bcftools apps/samtools/1.9 apps/tabix/0.2.5 lib/htslib/1.10.2-gcc

python getENCODEvalues.py $1 $2
