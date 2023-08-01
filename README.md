# DrivR-Base

## Introduction and Overview
The following repository contains scripts for extracting feature information for single nucleotide variants of interest. 

## Table of Contents

- [Data Input Structure](#data-input-structure)
- [Installation](#installation)
- [Directory Structure](#directory-structure)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Changelog](#changelog)
- [FAQ](#faq)
- [Contact](#contact)

## Data Input Structure
All variant files must be presented in the format shown in Table 1.

| Chromosome | Position | Position | Reference Allele | Alternate Allele | Recurrence | Driver Status |
| ---------- | -------- | -------- | ---------------- | ---------------- | ---------- | ------------- |
|    chr1    |  934881  |  934881  |        A         |         G        |      1     |       1       |

## Installation

## Directory Structure
```bash
DrivR-Base/
|-- FG1_conservation/
|   |-- 1_reformat.sh
|   |-- 2_get_cons_features.sh
|   |-- check_formatting.py
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

## Usage
### FG1_conservation
#### 1_reformat.sh

## Acknowledgments
Tom Gaunt
Colin Campbell
Cancer Research UK
University of Bristol
MRC Integrative Cancer Epidemiology Unit

## Contact
amy.francis@bristol.ac.uk

