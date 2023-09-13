# FG5: GC Content & CpG sites

## Introduction

The FG5_gc_CpG module is designed to calculate and analyze GC content and CpG-related features within nucleotide windows for given variants. By querying the human GRCh38 genome, this script enables the extraction of relevant sequence information and the calculation of essential molecular properties.

## Installation and Dependencies
Please configure the required packages for this module in the top-level directory **/DrivR-Base**. Importantly, make sure that the anaconda environment is loaded properly.

## Prerequisites
Before running the script, ensure you have the human genome in GRCh38 fasta format for accurate querying of nucleotide windows. The genome can be downloaded from NCBI. To proceed, update the "hg38_seq" variable in the config.py file to specify the path to your downloaded genome.

## Usage

### `get_gc_CpG.py`

This script performs the following tasks:
1. Variant Query and Sequence Extraction: Similar to the approach used in the FG3_dinucleotide_properties and FG4_dna_shape modules, this script queries the GRCh38 genome for provided variants within a specified window size. Unlike the other scripts, this Python script requires the pre-downloaded GRCh38 genome for accurate querying. Make sure to update the "hg38_seq" variable in config.py before running the script.
2. Calculation of GC Content, CpG Count, and CpG Observed/Expected Ratio: The script calculates GC content using the formula (wildType.count("G") + wildType.count("C")) / len(wildType) * 100. Additionally, CpG count is computed with wildType.count("CG"), and CpG observed/expected ratio is calculated using (CpGCount * len(wildType)) / (wildType.count("G") * wildType.count("C")).

### Script Input

The input variant file should be in **.BED** format, tab-delimited, with the chromosome labeled as "chr". Example:

| Chromosome | Position | Position | Reference Allele | Alternate Allele |
| ---------- | -------- | -------- | ---------------- | ---------------- |
|    chr1    |  934881  |  934881  |        A         |         G        | 

Refer to the variant.bed file in the /DrivR-Base/Example folder for guidance.

### Script execution
To execute the script, navigate to the /FG3_dna_shape directory and run:

```bash
python get_gc_CpG.py $variantDir $variantFileName $outputDir
```

* $variantDir: Location of the variant file (ends with /).
* $variantFileName: Name of the variant file.
* $outputDir: Location to store the resulting file (ends with /).

## Conclusion
The FG5_gc_CpG module provides a powerful tool for extracting and analyzing nucleotide sequences, contributing to a deeper understanding of GC content and CpG-related features within the context of genetic variants. By leveraging the GRCh38 genome and executing comprehensive calculations, this module facilitates valuable insights into molecular properties. For detailed instructions and examples on using the scripts, please refer to the respective script documentation.

