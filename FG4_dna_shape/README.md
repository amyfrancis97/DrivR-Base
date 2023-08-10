# FG4_dna_shape
## Introduction and Overview

## Directory Structure

```bash
DrivR-Base/
|-- FG4_dna_shape/
|   |-- 1_get_dna_shape.sh
|   |-- dna_shape.R
|   |-- package_dependencies.R
```
## Packages and Dependencies

Efficient management of packages and dependencies is ensured through the following file:

* **package_dependencies.R**: Manages the installation and maintenance of required R packages.

## Script Usage
The core script here is dna_shape.R. this script carrys out the following:
1. Variant Query and Sequence Extraction: The script queries the provided variant against the Hsapiens GRCh38 genome using the getFasta function. This operation yields information for the wild-type sequence only, spanning 21 base pairs. the 11th base pair position encompasses the variant.
2. Extract DNA shape features: using the 21 base pair sequence, the script extracts DNA shape features using the getShape function in the DNAshapeR package. This provides five different features for each nucleotide position in the 21bp sequence. The features are  minor groove width (MGW), Roll, propeller twist (ProT),
and helix twist (HelT), and electrostatic potential (EP).
3. output structuring: the script generates a table where the row is the variant, and the columns represent the value for each feature at each given nucleotide position in the wild type sequence.
