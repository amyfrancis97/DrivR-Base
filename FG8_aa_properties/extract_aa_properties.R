# Import the AAdata matrix from the peptides package
# The matrix contains different amino acid properties 
# Relating to each of the 20 amino acids
# Get DNA shapes of 10 BP regions overlapping with variant
# Load project path and any other variables
source("config.R")

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

library("data.table")
load(aa_properties)

round_df <- function(df, digits) {
  nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))

  df[,nums] <- round(df[,nums], digits = digits)

  (df)
}

args <- commandArgs()
print(args)
featureDir = args[6]

# # Upload amino acid changes associated with variants from the VEP AA output
AA=read.table(paste(featureDir, "vepAA.bed", sep = ""), sep = "\t", header = TRUE)

# Drop any variants where amino acids are unkown in the dataset
AA = AA[AA['WT_AA'] != "-", ]
AA = AA[AA['mutant_AA'] != "-", ]

# For each variant, pull out the scores for both the wild type and mutant amino acid
getAAExtraProperties = function(variant){
  datalist2=list()
  datalist = c()
  for(i in c("WT_AA", "mutant_AA")){
    if( AA[variant, i] %in% colnames(AAindex)){
      data = AAindex[, AA[variant, i]]
    }else{
      data = rep(NA,nrow(AAindex))
    }
    datalist = c(datalist, data)
    datalist2[[i]] = data
  }
  return(datalist)
  
}

# Carry out function to retrieve amino acid properties for each variant
x = 1:nrow(AA)
lists=lapply(x, getAAExtraProperties)

# Melt lists of variants into a dataframe
df = do.call(rbind, lists)

# Write CSV
# Resultant table are two concatenated vectors
# Vector 1: properties for wild type amino acid
# Vector 2: properties for mutant amino acid
# If synonymous, then the two vectors are identical
colnames(df) = c(paste("WT_AA", AAindex$name, sep = "_"), paste("mutant_AA", AAindex$name, sep = "_"))
df = cbind(AA[, 1:4], df)
df = round_df(df, 4)
name = paste(featureDir,"AAproperties.txt", sep = "")
write.table(df, name, quote = FALSE, row.names = FALSE, sep = "\t")
# %%

