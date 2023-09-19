#!/bin/bash
# Load required modules
source config.sh

# Print input arguments
echo "Input files: ${1}${2}"
basename="${2%.bed}"

# Reformatting step
cat "${1}${2}" | awk '{print $1"\t"$2-1"\t"$2"\t"$4"\t"$5}' | bedtools sort -i > "${3}${basename}.reformatted.bed"

# Perform additional checks
python check_formatting.py "${3}${basename}.reformatted.bed" "${3}${basename}.reformatted.sorted.bed"

wait 

# Set the directory for conservation files
cd $download_cons_dir

# Conservation files≈
#files=(phyloP4way phyloP7way phyloP17way phyloP20way phyloP30way phyloP100way phyloP470way phastCons4way phastCons7way phastCons17way phastCons20way phastCons30way phastCons100way phastCons470way k24.Bismap.MultiTrackMappability k36.Umap.MultiTrackMappability k36.Bismap.MultiTrackMappability k24.Umap.MultiTrackMappability k50.Bismap.MultiTrackMappability k50.Umap.MultiTrackMappability k100.Bismap.MultiTrackMappability k100.Umap.MultiTrackMappability)
files=(phyloP4way phyloP7way)
# Download and convert from .bigwig to .bedGraph as separate array jobs
#for file in "${files[@]}"; do
 # if [[ "$file" =~ way ]]; then
 # fileName="hg38.${file}.bw"
  #filePath="http://hgdownload.cse.ucsc.edu/goldenpath/hg38/${file}/hg38.${file}.bw"
  #else
  #fileName="${file}.bw"
  #filePath="http://hgdownload.soe.ucsc.edu/gbdb/hg38/hoffmanMappability/${file}.bw"
  #fi

  # Get the value of the 'file' variable exported from the main script
  #output_file="${fileName%.bw}.bedGraph"

  # Download the file and convert from .bigwig to .bedGraph
  #wget "$filePath"

  #wait

  #bigWigToBedGraph "${fileName}" "${output_file}"

  #wait 

  #rm "${file}.bw"
  #rm "hg38.${file}.bw";
#done

#wait 

# Set the directory for conservation files
cd $download_cons_dir
echo $download_cons_dir

# Get all available conservation feature datasets for querying
data=(*.bedGraph)
echo ${data[@]}

for i in ${data[@]}; do
echo "feature="
echo $i
# Specify input and output directories
inputDir="${1}"
echo "inputDir="
echo "${1}"
outputDir="${3}"
echo "outputDir="
echo "${3}"

mkdir -p "$outputDir"

# Specify variant datasets
reformattedOutput="${3}${basename}.reformatted.sorted.bed"
echo "reformattedOutput="
echo "${reformattedOutput}"

echo "outputFinal:"
echo "${outputDir}${i}"

# Find intersects between cosmic/gnomad data and conservation scores
bedtools intersect -wa -wb -a "$i" -b "$reformattedOutput" -sorted | awk '{print $5"\t"$7"\t"$8"\t"$9"\t"$4}' > "${outputDir}${i}"
wait;
done
