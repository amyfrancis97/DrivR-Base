# Set library path
source("packages.R")
if (!require("bios2mds", quietly = TRUE))
    BiocManager::install('bios2mds', quietly = TRUE, force = TRUE, INSTALL_opts = '--no-lock')

library('bios2mds')
data(sub.mat)


