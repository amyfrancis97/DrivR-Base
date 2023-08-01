# DrivR-Base

## Table of Contents

- [Installation](#installation)
- [Directory Structure](#directory-structure)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Changelog](#changelog)
- [FAQ](#faq)
- [Contact](#contact)

## Installation

## Directory Structure
```bash
DrivR-Base/
|__ FG1_conservation/
|   |__ 1_reformat.sh
|   |__ 2_get_cons_features.sh
|   |__ check_formatting.py
|-- FG2_vep/
|   |__ 1_get_vep_cache.sh
|   |__ 2_query_vep_cache.sh
|   |__ 3_reformat_vep_output.sh
|   |__ query_vep.sh
|   |__ reformat_vep.sh
|   |__ reformat_vep_aa.py
|   |__ reformat_vep_conseq.py
|   |__ reformat_vep_distance.py
|-- FG3_dinucleotide_properties/
|   |-- 1_get_dinuc_properties.sh
|   |-- dinucleotide_properties.R
|-- FG4_dna_shape/
|   |-- 1_get_dna_shape.sh
|   |-- dna_shape.R
|-- FG5_gc_CpG/
|   |-- 1_get_gc_CpG.sh
|   |-- get_gc_CpG.py
|-- FG6_kernel/
|   |-- 1_get_kernel.sh
|   |-- get_kernel.py
|-- FG7_aa_substitution_matrices/
|   |-- 1_get_aa_matrices.sh
|   |-- get_subs_matrix_table.R
|   |-- aa_subs_matrices.R
|-- FG8_aa_properties
|   |-- 1_get_aa_properties.sh
|   |-- extract_aa_properties.R
|-- FG9_encode/
|   |-- 11_getENCODEdatasets.sh
|   |-- getENCODEdatasets.sh
|   |-- getENCODEintersects.sh
|   |-- getENCODEvalues.sh
|   |-- getENCODEdatasets.py
|   |-- getENCODEvalues.py
|-- FG10_alpha_fold/
|   |-- get_alpha_fold_scores.sh
|   |-- get_alpha_fold_atom.py
|   |-- get_alpha_fold_struct_conf.py
```

## Usage
### FG1_conservation
#### 1_reformat.sh
