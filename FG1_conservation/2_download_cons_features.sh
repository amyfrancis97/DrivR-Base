#!/bin/bash
#SBATCH --job-name=DownloadConservationFeatures
#SBATCH --partition=test,short,mrcieu,compute
#SBATCH --mem=80G
#SBATCH --time=5-00:00:00
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG1_conservation
#SBATCH --account=sscm013903

# Load required modules
./module_dependencies.sh

# Set the directory for conservation files
featureDir="/bp1/mrcieu1/data/ucsc/public/ConsAll/"
cd "$featureDir"

# Conservation files
files=(
  phyloP4way phyloP7way phyloP17way phyloP20way phyloP30way phyloP100way phyloP470way
  phastCons4way phastCons7way phastCons17way phastCons20way phastCons30way phastCons100way phastCons470way
)

# Download and convert from .bigwig to .bedGraph as separate array jobs
for file in "${files[@]}"; do
  filePath="http://hgdownload.cse.ucsc.edu/goldenpath/hg38/${file}/hg38.${file}.bw"
  sbatch --export=file="${file}" /user/home/uw20204/DrivR-Base/FG1_conservation/download_convert.job
done

# Additional conservation files
files=(
  k24.Bismap.MultiTrackMappability k36.Umap.MultiTrackMappability k36.Bismap.MultiTrackMappability
  k24.Umap.MultiTrackMappability k50.Bismap.MultiTrackMappability k50.Umap.MultiTrackMappability
  k100.Bismap.MultiTrackMappability k100.Umap.MultiTrackMappability
)

# Download and convert from .bigwig to .bedGraph as separate array jobs
for file in "${files[@]}"; do
  filePath="http://hgdownload.soe.ucsc.edu/gbdb/hg38/hoffmanMappability/${file}.bw"
  sbatch --export=file="${file}" /user/home/uw20204/DrivR-Base/FG1_conservation/download_convert.job
done


