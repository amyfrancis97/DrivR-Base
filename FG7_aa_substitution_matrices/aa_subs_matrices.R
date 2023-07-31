# Get amino acid substitution matrices
# Extract score for each amino acid change in each matrix
source("/user/home/uw20204/CanDrivR_scripts/features_v2/packages.R")

args <- commandArgs()
featureDir <- args[6]

# Upload amino acid changes associated with variants from the VEP AA output
AA <- read.table(paste0(featureDir, "vepAA.bed"), sep = "\t", header = TRUE)

# Drop any variants where amino acids are unknown in the dataset
AA <- AA[AA$WT_AA != "", ]
AA <- AA[AA$mutant_AA != "", ]

# Set the number of cores to use for parallel processing
numCores <- detectCores()

# Initialize parallel backend
cl <- makeCluster(numCores)
registerDoParallel(cl)

# Function to calculate scores for a single variant
calculateScores <- function(variantRow) {
  result <- foreach(subMatrix = names(sub.mat), .combine = rbind) %dopar% {
    scores <- data.frame(sub.mat[[subMatrix]])[AA[variantRow, 'WT_AA'], gsub(" ", "", paste(names(sub.mat[[subMatrix]]), '.', AA[variantRow, 'mutant_AA']))]
    return(scores)
  }
  return(result)
}

# Calculate scores in parallel for each variant
variantScores <- foreach(i = 1:nrow(AA), .packages = c("foreach", "doParallel")) %dopar% {
  calculateScores(i)
}

# Stop parallel backend
stopCluster(cl)

# Combine scores for all variants into a single data frame
AA <- cbind(AA, do.call(rbind, variantScores))

# Write matrix to CSV
colnames(AA) <- c(colnames(AA[, 1:8]), names(sub.mat))
AA <- AA[, !(names(AA) %in% c("WT_AA", "mutant_AA"))]

name <- paste0(featureDir, "aa_subst_matrices.txt")
write.table(AA, name, quote = FALSE, row.names = FALSE, sep = "\t")

