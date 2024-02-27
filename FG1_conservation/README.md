# FG1: Conservation-based Features

## Introduction

The **FG1_conservation** module streamlines the retrieval and conversion of conservation and uniqueness data from the UCSC genome browser. It provides scripts and resources to simplify this process.

## Installation and Dependencies

Please configure the required packages for this module in the top-level directory **/DrivR-Base**.

Ensure that the following dependencies are installed:
- **bedtools**: Essential for executing the *bigWigToBedGraph* command.

## Usage

### `get_conservation.sh`

This script performs the following tasks:
1. Reformats the input variant file to match UCSC format.
2. Downloads 22 conservation and mappability datasets from UCSC golden path.
3. Converts downloaded files from *.bigwig* to *.bedGraph* format.
4. Queries the resulting files against input variants.

**Note:** This script downloads all conservation data locally for querying and temporarily requires approximately 1TB of space. Update the *download_cons_dir* in the *config.sh* file to a location with sufficient space.

### Script Input

The input variant file should be in **.BED** format, tab-delimited, with the chromosome labeled as "chr". Example:

| Chromosome | Position | Position | Reference Allele | Alternate Allele |
| ---------- | -------- | -------- | ---------------- | ---------------- |
|    chr1    |  934881  |  934881  |        A         |         G        | 

Refer to the variant.bed file in the /DrivR-Base/Example folder for guidance.

### Script execution
To execute the script, navigate to the /FG1_conservation module directory and run:

```bash
./get_conservation.sh $variantDir $variantFileName $outputDir
```

* $variantDir: Location of the variant file (ends with /).
* $variantFileName: Name of the variant file.
* $outputDir: Location to store the resulting file (ends with /).

## Conclusion
The FG1_conservation module simplifies reformatting, downloading, and converting conservation and uniqueness files, enhancing the efficiency of genomic analysis workflows.
