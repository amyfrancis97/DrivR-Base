# Set library path
path <- "/bp1/mrcieu1/data/encode/public/packages"
.libPaths(path)

install.packages("GenomicRanges", repos = "http://cran.us.r-project.org", INSTALL_opts = '--no-lock')
library(GenomicRanges)
install.packages("Biostrings", repos = "http://cran.us.r-project.org", INSTALL_opts = '--no-lock')
library(Biostrings)
install.packages("dplyr", repos = "http://cran.us.r-project.org", INSTALL_opts = '--no-lock')
library(dplyr)
