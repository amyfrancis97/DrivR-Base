# Get DNA shapes of 10 BP regions overlapping with variant
# Load project path and any other variables
source("/opt/vep/.vep/FG3_dinucleotide_properties/config.R")

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

args <- commandArgs()
# Reads in variant file in the format: "chrom", "start", "end", "ref", "alt"

variantDir=args[6]
file=args[7]
featureOutputDir=args[8]

variants = read.table(paste(variantDir, file, sep = ""), sep = "\t")
colnames(variants) = c("chrom", "start", "end", "ref", "alt")

# Read in dinucleotide properties
dinucleotideProperty=read.csv(dinucleotidePropertyTable)

# Create an empty dataframe to store the merged results
mergedVariants <- data.frame()

getDinucleotideProperties = function(chrom, variants){
    tryCatch(
    {
        chrom=paste("chr", chrom, sep = "")
        # import variants
        variants = variants[variants$chrom == chrom, ]
        variants2 = variants

        # Get the desired base pair range for DNA shape
        variants2[2] = variants2[2]-1
        variants2[3] = variants2[3]+1

        # Make a GRRanges object
        variants2 = makeGRangesFromDataFrame(variants2)

        # Get the 10bp fasta for each variant
        getFasta(variants2, BSgenome = Hsapiens, width = 3, filename = paste(chrom, "VariantDinucleotides.fa", sep = "_"))

        # Import variants for shaping
        VariantDinucleotideWTSeq=read.table(paste(chrom, "VariantDinucleotides.fa", sep = "_"))
        toDelete <- seq(1, nrow(VariantDinucleotideWTSeq), 2)
        variants = cbind(variants, VariantDinucleotideWTSeq[ -toDelete ,])
        getMutantTrinucleotides = function(variantRow){
        mutantTrinucleotides = paste(substr(variants[variantRow, 6], 1, 1), variants[variantRow, 5], substr(variants[variantRow, 6], 3, 3), sep = "")
        return(mutantTrinucleotides)
        }

        # Carry out function to retrieve mutant trinucleotides for each variant
        variantdfapply <- lapply(1:nrow(variants), getMutantTrinucleotides)

        # Melt lists of variants into a dataframe
        variantdf = do.call(rbind.data.frame, variantdfapply)
        variants = cbind(variants, variantdf)
        colnames(variants) = c("chrom", "start", "end", "ref_allele", "alt_allele", "WTtrinuc", "mutTrinuc")

        # Get names of dinucleotide properties
        dinucleotidePropertyNames = apply(dinucleotideProperty['PropertyName'],2,function(x)gsub('\\s+', '_',x))

        # Function gets dinucleotideproperties for trinucleotide
        getDinucleotidePropertyVector = function(variantRow){
        di1 = paste(substr(variants[variantRow, 'WTtrinuc'], 1, 1), substr(variants[variantRow, 'WTtrinuc'], 2, 2), sep = "") # position1-position2 of WT
        di2 = paste(substr(variants[variantRow, 'WTtrinuc'], 2, 2), substr(variants[variantRow, 'WTtrinuc'], 3, 3), sep = "") # position3-position4 of WT
        di3 = paste(substr(variants[variantRow, 'mutTrinuc'], 1, 1), substr(variants[variantRow, 'mutTrinuc'], 2, 2), sep = "") # position1-position2 of mutant
        di4 = paste(substr(variants[variantRow, 'mutTrinuc'], 2, 2), substr(variants[variantRow, 'mutTrinuc'], 3, 3), sep = "") # position3-position4 of mutant
        distr = paste(di4, paste(di3, paste(di1, di2, sep = ""), sep = ""), sep = "")
        if(grepl("N", distr) == TRUE){
            w = variantdf[variantRow, ]
            x = data.frame(matrix(NA,    # Create empty data frame
                                    nrow = 4*124, # number of dinucleotide properties * 4
                                    ncol = 1))
            z = cbind(w, x)
        }else{
            w = variantdf[variantRow, ]
            x = cbind(t(dinucleotideProperty[di1]), t(dinucleotideProperty[di2]))
            y = cbind(t(dinucleotideProperty[di3]), t(dinucleotideProperty[di4]))
            z = cbind(w, cbind(x, y))
        }
        return(z)
        }

        # Carry out function to retrieve mutant dinucleotide properties for each variant
        # Four concatenated vectors
        dinucleotides <- lapply(1:nrow(variants), getDinucleotidePropertyVector)

        # Apply length function to each element in the dinucleotides list
        lengths <- sapply(dinucleotides, function(x) ncol(x))

        # Check if all lengths are the same
        if (all(lengths == lengths[1])) {
        } else {
        
        # Identify inconsistent lengths
        inconsistent_indices <- which(lengths != lengths[1])
        
        # Remove inconsistent lengths from dinucleotides list
        dinucleotides <- dinucleotides[-inconsistent_indices]
        
        # Remove corresponding rows from variants dataframe
        variants <- variants[-inconsistent_indices, ]
        }

        # Melt lists of variants into a dataframe
        variantdf <- do.call(rbind.data.frame, dinucleotides)

        variants <- cbind(variants, variantdf)
        variants = variants %>%
        select(-"w")
        colnames(variants)[8:length(colnames(variants))] = c(paste("1", dinucleotidePropertyNames, sep = "_"), paste("2", dinucleotidePropertyNames, sep = "_"), 
                                                paste("3", dinucleotidePropertyNames, sep = "_"), paste("4", dinucleotidePropertyNames, sep = "_"))
        # only keep one column if they are duplicated
        variants <- variants[, !duplicated(colnames(variants), fromLast = TRUE)]

        variants = variants %>% 
        rename(
            "pos" = "start",
            )

        variants = variants[, -3]

        # Append the variants dataframe to the mergedVariants dataframe
        mergedVariants <<- rbind(mergedVariants, variants)
	file.remove(paste(chrom, "VariantDinucleotides.fa", sep = "_"))
        return(variants)    },
    error = function(e) {
      # Print the error message if an error occurs
      cat("Warning for chromosome", chrom, ":", conditionMessage(e), "\n")
    }
  )
}

for(i in 1:22){
    try(getDinucleotideProperties(i, variants))
}

# Write the merged results to a CSV file
outputFile <- file.path(featureOutputDir, "dinucleotideProperties.txt")
write.table(mergedVariants, outputFile, quote = FALSE, row.names = FALSE, sep = "\t")
