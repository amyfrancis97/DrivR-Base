# Set library path
path <- "/bp1/mrcieu1/data/encode/public/packages"
.libPaths(path)

# Check and install required packages
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos = "http://cran.us.r-project.org", INSTALL_opts = '--no-lock')
if (!require("BSgenome", quietly = TRUE))
    BiocManager::install("BSgenome", force = TRUE, INSTALL_opts = '--no-lock')
if (!require("BSgenome.Hsapiens.UCSC.hg38", quietly = TRUE))
    BiocManager::install('BSgenome.Hsapiens.UCSC.hg38', quietly = TRUE, force = TRUE, INSTALL_opts = '--no-lock')
if (!require("DNAshapeR", quietly = TRUE))
    BiocManager::install('DNAshapeR', quietly = TRUE, force = TRUE, INSTALL_opts = '--no-lock')
if (!require("dplyr", quietly = TRUE)) 
    install.packages('dplyr', quietly = TRUE, force = TRUE, repos = "http://cran.us.r-project.org", INSTALL_opts = '--no-lock')
install.packages("tidyverse", quietly = TRUE, repos = "http://cran.us.r-project.org", force = TRUE, dependencies = TRUE, INSTALL_opts = '--no-lock')

#if (!require("DNAshapeR", quietly = TRUE))
#    BiocManager::install('bios2mds', quietly = TRUE, force = TRUE, INSTALL_opts = '--no-lock')

#library('bios2mds')


# Load required libraries
library('BSgenome', lib.loc = "/bp1/mrcieu1/data/encode/public/packages")
library('BSgenome.Hsapiens.UCSC.hg38', lib.loc = "/bp1/mrcieu1/data/encode/public/packages")
library('DNAshapeR')
library('GenomicRanges')
library('dplyr')
library('stringr')
library("tidyverse")
source("/user/home/uw20204/CanDrivR_scripts/features_v2/config.R")

# Get amino acid substitution matrices
install.packages("Peptides", dependencies = TRUE, repos = "http://cran.us.r-project.org", force = TRUE, INSTALL_opts = '--no-lock')
install.packages("devtools", dependencies = TRUE, repos = "http://cran.us.r-project.org", force = TRUE, INSTALL_opts = '--no-lock')

library(devtools)
install_github("dosorio/Peptides")
library(Peptides)
data("AAdata")
library("tidyr")

install.packages("data.table", dependencies = TRUE, repos = "http://cran.us.r-project.org", force = TRUE, INSTALL_opts = '--no-lock')
library("data.table")

# Load the data list from the file
sub.mat <- readRDS("/user/home/uw20204/CanDrivR_scripts/features_v2/FG7_aa_substitution_matrices/sub.mat.RDS")
print(sub.mat)

install.packages("doParallel", dependencies = TRUE, repos = "http://cran.us.r-project.org", force = TRUE, INSTALL_opts = '--no-lock')  # Install if not already installed
install.packages("foreach", dependencies = TRUE, repos = "http://cran.us.r-project.org", force = TRUE, INSTALL_opts = '--no-lock')
library(doParallel)            # Load the doParallel package
library(foreach)
install.packages("doSNOW", dependencies = TRUE, repos = "http://cran.us.r-project.org", force = TRUE, INSTALL_opts = '--no-lock')
library(doSNOW)
