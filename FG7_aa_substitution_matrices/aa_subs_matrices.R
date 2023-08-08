# Get amino acid substitution matrices
# Extract score for each amino acid change in each matrix
source("package_dependencies.R")

args <- commandArgs()
featureDir = args[6]
# # Upload amino acid changes associated with variants from the VEP AA output
AA=read.table(paste(featureDir, "vepAA.bed", sep = ""), sep = "\t", header = TRUE)

print(head(AA))
# Drop any variants where amino acids are unkown in the dataset
AA = AA[AA['WT_AA'] != "-", ]
AA = AA[AA['mutant_AA'] != "-", ]

# For each variant, get the score from each amino acid matrix
for(subMatrix in as.list(names(sub.mat))){
  getSubstitMatScores = function(variantRow){
    res = data.frame(sub.mat[subMatrix])[AA[variantRow, 'WT_AA'], gsub(" ", "",paste(names(sub.mat[subMatrix]), '.', AA[variantRow, 'mutant_AA'])) ]
    return(res)
  }
  test <- lapply(1:nrow(AA), getSubstitMatScores)
  test[sapply(test, is.null)] <- NA
  test = unlist(test, recursive = TRUE, use.names = TRUE)
  AA = cbind(AA, test)
}

# Write matrix to CSV
colnames(AA) = c(colnames(AA[, 1:8]), names(sub.mat))
AA = AA[ , !(names(AA) %in% c("WT_AA", "mutant_AA"))]
name = paste(featureDir,"AASubstMatrices.txt", sep = "")
write.table(AA, name, quote = FALSE, row.names = FALSE, sep = "\t")
