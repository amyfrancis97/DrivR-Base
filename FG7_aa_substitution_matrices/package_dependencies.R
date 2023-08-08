# Set library path
path <- "/bp1/mrcieu1/data/encode/public/packages"
.libPaths(path)

# Check and install required packages
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos = "http://cran.us.r-project.org", INSTALL_opts = '--no-lock')
if (!require("dplyr", quietly = TRUE)) 
    install.packages('dplyr', quietly = TRUE, force = TRUE, repos = "http://cran.us.r-project.org", INSTALL_opts = '--no-lock')

library('dplyr')
library('stringr')
library("tidyverse")
source("/user/home/uw20204/DrivR-Base/config.R")

# Load the data list from the file
sub.mat <- readRDS("/user/home/uw20204/DrivR-Base/FG7_aa_substitution_matrices/sub.mat.RDS")
print(sub.mat)
