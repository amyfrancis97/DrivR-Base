# FG6: Amino Acid Substitution Matrices

## Introduction
The **FG7_aa_substitution_matrices** script utilizes 13 different substitution matrices sourced from [Bio2mds](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3403911/) to perform queries on predicted mutant and wild type amino acids against a database. This functionality provides valuable insights into the evolutionary frequency of amino acid substitutions. These insights can aid in assessing amino acid conservation, particularly when analyzing non-synonymous variants.

## Installation and Dependencies
Please configure the required packages for this module in the top-level directory **/DrivR-Base**. Importantly, make sure that the anaconda environment is loaded properly.

## Prerequisites
Before executing the script, ensure you have the human genome in GRCh38 fasta format to enable accurate querying of nucleotide windows and k-mers. You can download the genome from NCBI. To proceed, update the "hg38_seq" variable in the config.py file to specify the path to your downloaded genome.

## Usage

### `aa_subs_matrices.R`
This script leverages predicted amino acids for each variant (obtained from variant effect predictor) to retrieve substitution matrix values for both the wild type and mutant amino acids. When using this module as a standalone tool, adhere to the provided input data format and column names in the "vepAA.bed" file:

### Script execution
To execute the script, navigate to the /FG3_dna_shape directory and run:

```bash
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"
Rscript aa_subs_matrices.R $variantDir $variantFileName $outputDir
```

* $renv_dir: Location of the renv.lock file (within /DrivR-Base folder)
* $variantDir: Location of the variant file (ends with /).
* $variantFileName: Name of the variant file.
* $outputDir: Location to store the resulting file (ends with /).

## Conclusion
The incorporation of 13 substitution matrices and the subsequent analysis of amino acid substitutions provide valuable insights into the evolutionary dynamics of amino acids. This tool can assist researchers in assessing the conservation of specific amino acids and gaining a deeper understanding of the impact of non-synonymous variants. By utilizing this script, you can enhance your analysis of amino acid changes and their implications, contributing to a more comprehensive understanding of biological systems. For detailed instructions and examples on using the scripts, please refer to the respective script documentation.


