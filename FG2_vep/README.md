# FG2: Variant Effect Predictor

## Introduction
FG2_vep is a module within the DrivR-Base framework that provides a comprehensive toolkit for Variant Effect Prediction (VEP) analysis. It streamlines the process of downloading VEP cache, querying variants against the cache, and reformatting the query results. The module includes a set of scripts and resources to simplify and accelerate VEP analysis tasks.

## Installation and Dependencies
Please configure the required packages for this module in the top-level directory **/DrivR-Base**.

## Usage

### `get_vep.sh`

This script performs the following tasks:
1. Clones the VEP cache repository, installs required perl modules & downloads the GRCh38 genome.
2. Queries given variants against the VEP cache, and extracts predictions for:
    * Protein predictions
    * Transcript consequences
    * Amino Acids
    * Distances to transcripts
3. Reformats resulting files into a more human-readable format.

### Script Input

The input variant file should be in **.BED** format, tab-delimited, with the chromosome labeled as "chr". Example:

| Chromosome | Position | Position | Reference Allele | Alternate Allele |
| ---------- | -------- | -------- | ---------------- | ---------------- |
|    chr1    |  934881  |  934881  |        A         |         G        | 

Refer to the variant.bed file in the /DrivR-Base/Example folder for guidance.

### Script execution
To execute the script, navigate to the /FG1_conservation module directory and run:

```bash
./get_vep.sh $variantDir $variantFileName $outputDir
```

* $variantDir: Location of the variant file (ends with /).
* $variantFileName: Name of the variant file.
* $outputDir: Location to store the resulting file (ends with /).

## Conclusion
The FG2_vep module streamlines the process of querying the VEP cache and reformatting its output. Typically, the output from VEP is not very user-friendly. Therefore, researchers can use this pipeline to efficiently extract information from VEP, saving time that would otherwise be spent on data wrangling.
