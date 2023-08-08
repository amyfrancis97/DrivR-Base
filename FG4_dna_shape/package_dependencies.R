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


# Load required libraries
library('BSgenome', lib.loc = "/bp1/mrcieu1/data/encode/public/packages")
library('BSgenome.Hsapiens.UCSC.hg38', lib.loc = "/bp1/mrcieu1/data/encode/public/packages")
library('DNAshapeR')
library('GenomicRanges')
library('dplyr')
library('stringr')
library("tidyverse")
source("/user/home/uw20204/DrivR-Base/config.R")

