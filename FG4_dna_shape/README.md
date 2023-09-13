# FG4: DNA Shape

## Introduction

**FG4_dna_shape** is a module within the **DrivR-Base** framework designed to extract DNA shape features from genetic variant sequences. This module leverages the power of the DNAshapeR package to capture essential characteristics such as minor groove width (MGW), Roll, propeller twist (ProT), helix twist (HelT), and electrostatic potential (EP). By querying and analyzing variant sequences, researchers gain insights into how genetic variations impact the structural properties of DNA.

## Installation and Dependencies

Please configure the required packages for this module in the top-level directory **/DrivR-Base**.

## Usage

### `dna_shape.R`

This script performs the following tasks:
1. **Variant Query and Sequence Extraction**: The script initiates a query against the Hsapiens GRCh38 genome using the getFasta function, focusing on the provided variant. This operation yields valuable information about the wild-type sequence, spanning 21 base pairs. The variant's position is located at the 11th base pair.
2. **DNA Shape Feature Extraction**: Utilizing the 21-base pair sequence, the script employs the getShape function from the DNAshapeR package. This step extracts five distinct DNA shape features for each nucleotide position within the 21-base pair sequence. The features include minor groove width (MGW), Roll, propeller twist (ProT), helix twist (HelT), and electrostatic potential (EP).
3. **Output Structuring**: The script's output culminates in a structured table. Each row corresponds to a variant of interest, while the columns encapsulate the values of each extracted DNA shape feature at the respective nucleotide positions in the wild-type sequence.

### Script Input

The input variant file should be in **.BED** format, tab-delimited, with the chromosome labeled as "chr". Example:

| Chromosome | Position | Position | Reference Allele | Alternate Allele |
| ---------- | -------- | -------- | ---------------- | ---------------- |
|    chr1    |  934881  |  934881  |        A         |         G        | 

Refer to the variant.bed file in the /DrivR-Base/Example folder for guidance.

### Script execution
To execute the script, navigate to the /FG3_dna_shape directory and run:

```bash
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"
Rscript dna_shape.R $variantDir $variantFileName $outputDir
```

* $renv_dir: Location of the renv.lock file (located wihtin the /DrivR-Base folder)
* $variantDir: Location of the variant file (ends with /).
* $variantFileName: Name of the variant file.
* $outputDir: Location to store the resulting file (ends with /).

## Conclusion
By utilizing the **FG4_dna_shape** module, researchers unlock a powerful avenue for exploring how genetic variants influence the structural attributes of DNA. This module facilitates the extraction and interpretation of DNA shape features, aiding in the comprehension of how genetic variations impact DNA's dynamic architecture. For detailed instructions and examples on using the scripts, please refer to the respective script documentation.




