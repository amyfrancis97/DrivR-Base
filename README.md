# DrivR-Base

## Introduction and Overview
Welcome to DrivR-Base! This repository contains scripts for extracting feature information from different databases for single nucleotide variants (SNVs). These features are designed to be inputs for machine learning models, aiding in the prediction of functional impacts of genetic variants in human genome sequencing. The repository is organized into separate sub-directories for different feature groups (**FG_**), each serving a unique purpose.

## Table of Contents
- [Introduction and Overview](#introduction-and-overview)
- [Table of Contents](#table-of-contents)
- [Feature Descriptions and Sources](#feature-descriptions)
- [Data Input Structure](#data-input-structure)
- [Installation](#installation)
- [Directory Structure](#directory-structure)
- [Feature Description & Usage](#feature-description--usage)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Contact](#contact)

## Feature Descriptions and Sources

| Feature Group Label |                                             Feature Group Description                                            |                          Source                         |
| ------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
|         FG1         | 20 sequence conservation and uniqueness features from UCSC genome browser, including PhyloP and PhastCons scores | [UCSC](http://hgdownload.cse.ucsc.edu/goldenpath/hg38/) |
|         FG2         | 3 Variant Effect Predictor features, including amino acid prediction, consequences, and distances to transcripts | [VEP Cache](https://www.ensembl.org/info/docs/tools/vep/script/vep_cache.html) |
|         FG3         | 125 dinucleotide properties for wild-type and mutant nucleotide sequences                                        | [DiProGB](https://diprodb.fli-leibniz.de/ShowTable.php) |
|         FG4         | 5 DNA shape properties, including electrostatic potential and minor groove width                                 | [DNAshapeR](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4824130/) |
|         FG5         | GC-content and CpG counts for various window sizes                                                               | [Self-calculated](https://github.com/amyfrancis97/DrivR-Base/blob/main/FG5_gc_CpG/get_gc_CpG.py)
|         FG7         | scores for 13 different amino acid substitution matrices                                                         | [Bio2mds](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3403911/) |
|         FG8         | 533 amino acid properties for both wild-type and mutant amino acids                                              | [AAindex](https://academic.oup.com/nar/article/28/1/374/2384334?login=false) |
|         FG9         | Results for 10 different ENCODE assays, including transcription factor binding sites and histone modifications   | [ENCODE](https://www.encodeproject.org/)
|         FG10        | AlphaFold structural conformation and atom properties at the predicted amino acid site                           | [AlphaFold](https://alphafold.ebi.ac.uk/)


## Data Input Structure
All variant files must be presented in the format shown in the following table:

| Chromosome | Position | Position | Reference Allele | Alternate Allele | Recurrence | Driver Status |
| ---------- | -------- | -------- | ---------------- | ---------------- | ---------- | ------------- |
|    chr1    |  934881  |  934881  |        A         |         G        |      1     |       1       |

Importantly, the chromosomal position must exist in a string format with a prefix of "chr", and the positions must be in an integer format. The final two columns are optional and are not useful at this level of analysis. Hence, if these columns are not useful for the variants of interest, just fill these with a 0 or 1. This will not affect the analysis. Crucially, the chromosomal position **must** be in the GRCh38 reference genome format. All features are extracted and queried using these descriptors, if the variant is provided in the wrong reference genome, the feature information will be incorrect. 

## Installation

## Directory Structure
```bash
DrivR-Base/
|-- FG1_conservation/
|   |-- 1_reformat.sh
|   |-- 2_download_cons_features.sh
|   |-- 3_query_cons_features.sh
|   |-- check_formatting.py
|   |-- download_convert.job
|   |-- module_dependencies.sh
|   |-- package_dependencies.py
|
|-- FG2_vep/
|   |-- 1_get_vep_cache.sh
|   |-- 2_query_vep_cache.sh
|   |-- 3_reformat_vep_output.sh
|   |-- query_vep.sh
|   |-- reformat_vep.sh
|   |-- reformat_vep_aa.py
|   |-- reformat_vep_conseq.py
|   |-- reformat_vep_distance.py
|
|-- FG3_dinucleotide_properties/
|   |-- 1_get_dinuc_properties.sh
|   |-- dinucleotide_properties.R
|
|-- FG4_dna_shape/
|   |-- 1_get_dna_shape.sh
|   |-- dna_shape.R
|
|-- FG5_gc_CpG/
|   |-- 1_get_gc_CpG.sh
|   |-- get_gc_CpG.py
|
|-- FG6_kernel/
|   |-- 1_get_kernel.sh
|   |-- get_kernel.py
|
|-- FG7_aa_substitution_matrices/
|   |-- 1_get_aa_matrices.sh
|   |-- get_subs_matrix_table.R
|   |-- aa_subs_matrices.R
|
|-- FG8_aa_properties
|   |-- 1_get_aa_properties.sh
|   |-- extract_aa_properties.R
|
|-- FG9_encode/
|   |-- 11_getENCODEdatasets.sh
|   |-- getENCODEdatasets.sh
|   |-- getENCODEintersects.sh
|   |-- getENCODEvalues.sh
|   |-- getENCODEdatasets.py
|   |-- getENCODEvalues.py
|
|-- FG10_alpha_fold/
|   |-- get_alpha_fold_scores.sh
|   |-- get_alpha_fold_atom.py
|   |-- get_alpha_fold_struct_conf.py
```

## Feature Description & Usage
### FG1_conservation
#### 1_reformat.sh

## Contributing
Contributions are welcome! Follow the guidelines in CONTRIBUTING.md

## License
This project is licensed under [LICENSE](https://github.com/amyfrancis97/DrivR-Base/blob/main/LICENSE).

## Acknowledgments
Tom Gaunt
Colin Campbell
Cancer Research UK
University of Bristol
MRC Integrative Cancer Epidemiology Unit

## Contact
amy.francis@bristol.ac.uk

