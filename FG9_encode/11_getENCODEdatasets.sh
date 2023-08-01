#!/bin/bash
#SBATCH --job-name=getEncode
#SBATCH --partition=compute
#SBATCH --mem=150G
#SBATCH --time=4-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG9_encode
#SBATCH --account=sscm013903

# Download the ENCODE datasets
features=("TF+ChIP-seq" "Histone+ChIP-seq" "DNase-seq" "Mint-ChIP-seq" "ATAC-seq" "eCLIP" "ChIA-PET" "GM+DNase-seq" "STARR-seq")
features=("TF+ChIP-seq" "Histone+ChIP-seq" "ATAC-seq" "eCLIP")

#for feature in "${features[@]}"; do
 #   echo "$feature"
  #  sbatch getENCODEdatasets.sh "$feature" "/bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/"
#done

#for feature in "${features[@]}"; do
 #   sbatch getENCODEintersects.sh "/bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/" "$feature" "/bp1/mrcieu1/data/encode/public/cosmicSomaMutDB.bed"
#done

for feature in "${features[@]}"; do
    sbatch getENCODEvalues.sh "$feature" "/bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/" 
done

