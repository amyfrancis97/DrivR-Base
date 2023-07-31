#!/bin/bash
#SBATCH --job-name=getConservationFeatures
#SBATCH --partition=mrcieu,short,test,compute
#SBATCH --mem=80G
#SBATCH --time=5-00:00:00
#SBATCH --chdir=$4
#SBATCH --account=sscm013903
#SBATCH --array=1-20

# Load required modules
module load apps/bedops/2.4.38 apps/bedtools/2.30.0
module load apps/bcftools apps/samtools/1.9 apps/tabix/0.2.5 lib/htslib/1.10.2-gcc

# Download conservation files
# Install packages for conversions
conda install ucsc-bigwigtobedgraph

# Set the directory for conservation files
featureDir="/bp1/mrcieu1/data/ucsc/public/ConsAll/"
cd "$featureDir"

# Conservation files
files=(
  phyloP4way phyloP7way phyloP17way phyloP20way phyloP30way phyloP100way phyloP470way
  phastCons4way phastCons7way phastCons17way phastCons20way phastCons30way phastCons100way phastCons470way
)

# Download the files and convert from .bigwig to .bedGraph
for file in "${files[@]}"; do
  filePath="http://hgdownload.cse.ucsc.edu/goldenpath/hg38/${file}/hg38.${file}.bw"
  wget "$filePath"
  bigWigToBedGraph "${file}.bw" "${file}.bedGraph"
  rm "${file}.bw"
done

# Additional conservation files
files=(
  k24.Bismap.MultiTrackMappability k36.Umap.MultiTrackMappability k36.Bismap.MultiTrackMappability
  k24.Umap.MultiTrackMappability k50.Bismap.MultiTrackMappability k50.Umap.MultiTrackMappability
  k100.Bismap.MultiTrackMappability k100.Umap.MultiTrackMappability
)

# Download the files and convert from .bigwig to .bedGraph
for file in "${files[@]}"; do
  filePath="http://hgdownload.soe.ucsc.edu/gbdb/hg38/hoffmanMappability/${file}.bw"
  wget "$filePath"
  bigWigToBedGraph "${file}.bw" "${file}.bedGraph"
  rm "${file}.bw"
done

# Get all available conservation feature datasets for querying
data=("$featureDir"*.bedGraph)

# Submit a different array job for each feature dataset
feature="${data[${SLURM_ARRAY_TASK_ID} - 1]}"

echo "Current feature: $feature"

# Get the feature file name without the directory path
arrIN=(${feature//// })

# Specify input and output directories
inputDir="${1}"
outputDir="${3}"
mkdir -p "$outputDir"

# Specify variant datasets
reformattedOutput="${1}${2}"

start_time=$(date +%s)
# Find intersects between cosmic/gnomad data and conservation scores
bedtools intersect -wa -wb -a "$feature" -b "$reformattedOutput" -sorted |
  awk '{print $5"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$4}' > "${outputDir}${arrIN[6]}_cons.out.bed"
end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "Total execution time for bedtools intersect: $execution_time seconds"

