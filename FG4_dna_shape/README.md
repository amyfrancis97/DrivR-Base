# FG4_dna_shape

## Introduction and Overview
**FG4_dna_shape** is a module within the **DrivR-Base** framework designed to extract DNA shape features from genetic variant sequences. This module leverages the power of the DNAshapeR package to capture essential characteristics such as minor groove width (MGW), Roll, propeller twist (ProT), helix twist (HelT), and electrostatic potential (EP). By querying and analyzing variant sequences, researchers gain insights into how genetic variations impact the structural properties of DNA.

## Directory Structure

```bash
DrivR-Base/
|-- FG4_dna_shape/
|   |-- 1_get_dna_shape.sh
|   |-- dna_shape.R
|   |-- package_dependencies.R
```
## Packages and Dependencies

Streamlined management of packages and dependencies is facilitated through the following file:

* **package_dependencies.R**: Orchestrates the installation and maintenance of the required R packages, ensuring a seamless and consistent environment.

## Script Usage
The **dna_shape.R** script is central to this module's functionality, performing the following crucial tasks:

1. **Variant Query and Sequence Extraction**: The script initiates a query against the Hsapiens GRCh38 genome using the getFasta function, focusing on the provided variant. This operation yields valuable information about the wild-type sequence, spanning 21 base pairs. The variant's position is located at the 11th base pair.
2. **DNA Shape Feature Extraction**: Utilizing the 21-base pair sequence, the script employs the getShape function from the DNAshapeR package. This step extracts five distinct DNA shape features for each nucleotide position within the 21-base pair sequence. The features include minor groove width (MGW), Roll, propeller twist (ProT), helix twist (HelT), and electrostatic potential (EP).
3. **Output Structuring**: The script's output culminates in a structured table. Each row corresponds to a variant of interest, while the columns encapsulate the values of each extracted DNA shape feature at the respective nucleotide positions in the wild-type sequence.

## Conclusion
By utilizing the **FG4_dna_shape** module, researchers unlock a powerful avenue for exploring how genetic variants influence the structural attributes of DNA. This module facilitates the extraction and interpretation of DNA shape features, aiding in the comprehension of how genetic variations impact DNA's dynamic architecture.

For detailed guidance and illustrative examples of utilizing the scripts, please refer to the specific script documentation.



