#!/bin/bash

# Load required modules
source config.sh
source ${module_dependencies_loc}module_dependencies.sh

# Set the directory for conservation files
cd $download_cons_dir

# Conservation files≈
files=(
  phyloP4way phyloP7way phyloP17way phyloP20way phyloP30way phyloP100way phyloP470way
  phastCons4way phastCons7way phastCons17way phastCons20way phastCons30way phastCons100way phastCons470way
)

# Download and convert from .bigwig to .bedGraph as separate array jobs
for file in "${files[@]}"; do
  fileName="hg38.${file}.bw"
  filePath="http://hgdownload.cse.ucsc.edu/goldenpath/hg38/${file}/hg38.${file}.bw"
  sbatch --export=fileName="${fileName}",filePath="${filePath}" ${working_dir}download_convert.job 
done

# Additional conservation files
files=(
  k24.Bismap.MultiTrackMappability k36.Umap.MultiTrackMappability k36.Bismap.MultiTrackMappability
  k24.Umap.MultiTrackMappability k50.Bismap.MultiTrackMappability k50.Umap.MultiTrackMappability
  k100.Bismap.MultiTrackMappability k100.Umap.MultiTrackMappability
)

# Download and convert from .bigwig to .bedGraph as separate array jobs
for file in "${files[@]}"; do
  fileName="${file}.bw"
  filePath="http://hgdownload.soe.ucsc.edu/gbdb/hg38/hoffmanMappability/${file}.bw"
  sbatch --export=fileName="${fileName}",filePath="${filePath}" ${working_dir}download_convert.job
done


