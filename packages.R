if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", version = "3.16")
BiocManager::install(c("BSgenome", "bios2mds", "BSgenome.Hsapiens.UCSC.hg38", "DNAshapeR"))
path="/user/work/uw20204/"
install.packages(c("tzdb", "readr", "withr", "ps", "iterators", "ggplot2", "usethis", "dplyr", "tidyverse", "data.table", "devtools", "doParallel", "doSNOW", "foreach", "Peptides", "stringr", "tidyr", "Peptides", "devtools", "data.table"), dependencies = TRUE)
install_github("dosorio/Peptides")
