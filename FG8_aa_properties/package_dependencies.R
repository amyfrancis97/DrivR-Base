# Set library path
path <- "/bp1/mrcieu1/data/encode/public/packages"
.libPaths(path)

# Check and install required packages
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos = "http://cran.us.r-project.org", INSTALL_opts = '--no-lock')

source("config.R")


install.packages("data.table", dependencies = TRUE, repos = "http://cran.us.r-project.org", force = TRUE, INSTALL_opts = '--no-lock')
library("data.table")

# For each variant, pull out the scores for both the wild type and mutant amino acid
load(AA_properties)
