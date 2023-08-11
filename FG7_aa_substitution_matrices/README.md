# FG7_aa_substitution_matrices

## Overview
The **FG7_aa_substitution_matrices** script utilizes 13 different substitution matrices sourced from [Bio2mds](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3403911/) to perform queries on predicted mutant and wild type amino acids against a database. This functionality provides valuable insights into the evolutionary frequency of amino acid substitutions. These insights can aid in assessing amino acid conservation, particularly when analyzing non-synonymous variants.

## Directory Structure
The directory structure is as follows:
```bash
DrivR-Base/
|-- FG7_aa_substitution_matrices/
|   |-- 1_get_aa_matrices.sh
|   |-- get_subs_matrix_table.R
|   |-- aa_subs_matrices.R
|   |-- package_dependencies.R
|   |-- sub.mat.RDS
```

## Packages and Dependencies
Package dependencies are managed through the **package_dependencies.R** script.

## Prerequisite Data
To begin, the substitution matrices need to be downloaded from [Bio2mds](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3403911/). The dataset is provided as an R data file named **sub.mat.RDS**. Alternatively, you can use the **get_subs_matrix_table.R** script to download the dataset. Before proceeding, make sure to update the file path to the downloaded R data in the **config.R** file. This **config.R** file is then utilized in the **package_dependencies.R** script to load the data.

## Script Usage
The primary script for this analysis is **aa_subs_matrices.R**. This script leverages predicted amino acids for each variant (obtained from variant effect predictor) to retrieve substitution matrix values for both the wild type and mutant amino acids. When using this module as a standalone tool, adhere to the provided input data format and column names in the "vepAA.bed" file:

| chrom |  pos  | ref_allele | alt_allele |  R  | driver_stat | WT_AA | mutant_AA |
| ----- | ----- | ---------- | ---------- | --- | ----------- | ----- | --------- |
| chr1  | 935785|     C      |      A     |  2  |      1      |   L   |     I     |

## Conclusions
The incorporation of 13 substitution matrices and the subsequent analysis of amino acid substitutions provide valuable insights into the evolutionary dynamics of amino acids. This tool can assist researchers in assessing the conservation of specific amino acids and gaining a deeper understanding of the impact of non-synonymous variants. By utilizing this script, you can enhance your analysis of amino acid changes and their implications, contributing to a more comprehensive understanding of biological systems.



