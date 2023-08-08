#!/bin/bash
#SBATCH --job-name=queryConservationFeatures
#SBATCH --partition=mrcieu,short,test,compute
#SBATCH --mem=80G
#SBATCH --time=5-00:00:00
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG1_conservation
#SBATCH --account=sscm013903
#SBATCH --array=1-20

# Load required modules
./module_dependencies.sh

# Set the directory for conservation files
featureDir="/bp1/mrcieu1/data/ucsc/public/ConsAll/"
cd "$featureDir"

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

# Load required modules
module load apps/bedops/2.4.38 apps/bedtools/2.30.0
module load apps/bcftools apps/samtools/1.9 apps/tabix/0.2.5 lib/htslib/1.10.2-gcc

start_time=$(date +%s)
# Find intersects between cosmic/gnomad data and conservation scores
bedtools intersect -wa -wb -a "$feature" -b "$reformattedOutput" -sorted |
  awk '{print $5"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$4}' > "${outputDir}${arrIN[6]}_cons.out.bed"
end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "Total execution time for bedtools intersect: $execution_time seconds"

