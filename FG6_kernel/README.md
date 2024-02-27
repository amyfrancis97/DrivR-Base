# FG6: Kernel-based features

## Introduction
The FG6_kernel module employs spectrum kernels as a computational approach to comprehensively analyze potential disruptions occurring in sequences flanking a single nucleotide variant (SNV). Spectrum kernels serve to characterize the composition of k-mers within regions surrounding the SNV, both before and after the mutation. This approach enables the nuanced changes in sequence structure to be captured and quantified.

The outcome of the spectrum kernel algorithm results in two k-spectra: one representing the wild-type version of the sequence and the other representing the mutant version. These k-spectra encode the frequency and distribution of k-mers within their respective sequences. By concatenating these two k-spectra, a comprehensive representation is obtained, encapsulating the complete picture of sequence changes due to the SNV.

Leveraging spectrum kernels and the associated k-spectra, the goal is to capture and quantify the specific alterations and disruptions introduced by the SNV within the flanking sequence regions. This approach provides valuable insights into the impact of the SNV on the overall sequence composition, enhancing the understanding of potential functional consequences and their relevance in driver prediction.

## Installation and Dependencies
Please configure the required packages for this module in the top-level directory **/DrivR-Base**. Importantly, make sure that the anaconda environment is loaded properly.

## Prerequisites
Before executing the script, ensure you have the human genome in GRCh38 fasta format to enable accurate querying of nucleotide windows and k-mers. You can download the genome from NCBI. To proceed, update the "hg38_seq" variable in the config.py file to specify the path to your downloaded genome.

## Usage

### `get_kernel.py`

This script performs the following tasks:
1. **Variant Query and Sequence Extraction**: Similar to the approach used in FG5_gc_CpGs, the script queries the GRCh38 genome for provided variants within a specified window size.. Ensure that the "hg38_seq" variable in config.py is updated with the path to your downloaded genome. Sequences of window size w are generated for both wild type and mutant sequences.
2. **K-mer Generation**: An "over_slice()" function generates all possible combinations of k-mers of size k for each pair of wild-type and mutant variant sequences. This function generates substrings of length *k* by sliding a window of size *w* across the sequences, capturing local sequence patterns around the variants.
3. **Application of a Mapping Function**: Code is implemented to count the occurrence of each k-mer in each sequence.
4. **Derivation of a P-spectra Kernel**: Utilizing the mapping function, a p-spectrum kernel matrix is derived by summing the products of corresponding row entries for the two sequences.


### Script Input

The input variant file should be in **.BED** format, tab-delimited, with the chromosome labeled as "chr". Example:

| Chromosome | Position | Position | Reference Allele | Alternate Allele |
| ---------- | -------- | -------- | ---------------- | ---------------- |
|    chr1    |  934881  |  934881  |        A         |         G        | 

Refer to the variant.bed file in the /DrivR-Base/Example folder for guidance.

### Script execution
To execute the script, navigate to the /FG6_kernel directory and run:

```bash
python get_kernel.py $variantDir $variantFileName $outputDir
```

* $variantDir: Location of the variant file (ends with /).
* $variantFileName: Name of the variant file.
* $outputDir: Location to store the resulting file (ends with /).

## Conclusion
Overall, this script enables p-spectra to be calculated for different sequence lengths and k-mer sizes based on the requirements of the analysis.
By analysing the p-spectra matrices, it is possible to capture the similarities and dissimilarities between sequences, considering the patterns of k-mers of various sizes. This approach can provide valuable insights into the sequence variations induced by the variants and their potential impact on the overall sequence structure. For detailed instructions and examples on using the scripts, please refer to the respective script documentation.

