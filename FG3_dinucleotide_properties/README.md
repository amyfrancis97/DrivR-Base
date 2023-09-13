# FG3: Dinucleotide Properties

## Introduction

FG3_dinucleotide_properties, a module within DrivR-Base, analyzes the effects of genetic variants on dinucleotide properties. It allows exploration of 125 thermodynamic, structural, and other dinucleotide properties by querying variant sequences against a comprehensive database. This module facilitates insights into how variants impact nucleotide interactions.

## Installation and Dependencies

Configure the required packages for this module in the top-level directory **/DrivR-Base**.

### Prerequisites

To use the script successfully, download the **dinucleotidePropertyTable.csv** file, containing dinucleotide property data from DiProDB. This table encompasses 125 diverse properties.

## Usage

### `dinucleotide_properties.R`

This script performs the following tasks:

1. Variant Query and Sequence Extraction: Queries the variant against the Hsapiens GRCh38 genome to obtain wild-type and mutant sequences spanning three base pairs.

2. Dinucleotide Property Query: Utilizes the 3-base pair sequences to query the dinucleotide property database. Four dinucleotide configurations are considered for each variant, resulting in a table with 125 properties for each configuration.

3. Output Representation: Generates an output table where each row corresponds to a variant, and columns provide dinucleotide property values for each query configuration.

### Script Input

Input variant file in **.BED** format, tab-delimited, with the chromosome labeled as "chr". Example:

| Chromosome | Position | Position | Reference Allele | Alternate Allele |
| ---------- | -------- | -------- | ---------------- | ---------------- |
| chr1       | 934881   | 934881   | A                | G                | 

Refer to **variant.bed** in **/DrivR-Base/Example** for guidance.

### Script Execution

To run the script, navigate to the **/FG2_dinucleotide_properties** directory and execute:

```bash
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"
Rscript dinucleotide_properties.R $variantDir $variantFileName $outputDir
```

* $renv_dir: Location of the renv.lock file (within /DrivR-Base folder)
* $variantDir: Location of the variant file (ends with /).
* $variantFileName: Name of the variant file.
* $outputDir: Location to store the resulting file (ends with /).

## Conclusion
FG3_dinucleotide_properties enables a comprehensive assessment of genetic variant impacts on dinucleotide properties. It simplifies querying and analysis, facilitating deeper insights into nucleotide interactions and genetic variation contributions.

For detailed instructions and examples, consult the script documentation.

