# Get amino acid substitution matrices
# Extract score for each amino acid change in each matrix
# Get DNA shapes of 10 BP regions overlapping with variant

library(bios2mds)
library(BSgenome.Hsapiens.UCSC.hg38)
library(DNAshapeR)
library(usethis)
library(dplyr)
library(withr)
library(ggplot2)
library(tzdb)
library(readr)
library(tidyverse)
library(data.table)
library(ps)
library(devtools)
library(foreach)
library(iterators)
library(doParallel)
library(doSNOW)
library(Peptides)
library(stringr)
library(tidyr)
data(sub.mat)

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
colnames(AA) = c(colnames(AA[, 1:6]), names(sub.mat))
AA = AA[ , !(names(AA) %in% c("WT_AA", "mutant_AA"))]
#AA <- AA[-c(5,6)]
name = paste(featureDir,"AASubstMatrices.txt", sep = "")
write.table(AA, name, quote = FALSE, row.names = FALSE, sep = "\t")
