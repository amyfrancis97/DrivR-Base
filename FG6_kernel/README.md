# FG6_kernel

## Introduction and Overview
The FG6_kernel module employs spectrum kernels as a computational approach to comprehensively analyze potential disruptions occurring in sequences flanking a single nucleotide variant (SNV). Spectrum kernels serve to characterize the composition of k-mers within regions surrounding the SNV, both before and after the mutation. This approach enables the nuanced changes in sequence structure to be captured and quantified.

The outcome of the spectrum kernel algorithm results in two k-spectra: one representing the wild-type version of the sequence and the other representing the mutant version. These k-spectra encode the frequency and distribution of k-mers within their respective sequences. By concatenating these two k-spectra, a comprehensive representation is obtained, encapsulating the complete picture of sequence changes due to the SNV.

Leveraging spectrum kernels and the associated k-spectra, the goal is to capture and quantify the specific alterations and disruptions introduced by the SNV within the flanking sequence regions. This approach provides valuable insights into the impact of the SNV on the overall sequence composition, enhancing the understanding of potential functional consequences and their relevance in driver prediction.

## Directory Structure
```bash
DrivR-Base/
|-- FG3_kernel/
|   |-- 1_get_kernel.sh
|   |-- get_kernel.py
|   |-- package_dependencies.py
|   |-- config.py
```

## Packages and Dependencies
The management of packages and module dependencies is facilitated through the following files:

* **module_dependencies.sh**: Manages module-specific dependencies, ensuring a consistent environment.
* **package_dependencies.py**: Manages Python-specific dependencies, ensuring a consistent environment.

## Prerequisite data
Before executing the script, ensure you have the human genome in GRCh38 fasta format to enable accurate querying of nucleotide windows and k-mers. You can download the genome from NCBI. To proceed, update the "hg38_seq" variable in the config.py file to specify the path to your downloaded genome.

## Script Usage
The primary script, get_kernel.py, performs the following steps:

* **Variant Query and Sequence Extraction**: Similar to the approach used in FG5_gc_CpGs, the script queries the GRCh38 genome for provided variants within a specified window size.. Ensure that the "hg38_seq" variable in config.py is updated with the path to your downloaded genome. Sequences of window size w are generated for both wild type and mutant sequences.

* **K-mer Generation**: An "over_slice()" function generates all possible combinations of k-mers of size k for each pair of wild-type and mutant variant sequences. This function generates substrings of length *k* by sliding a window of size *w* across the sequences, capturing local sequence patterns around the variants.

* **Application of a Mapping Function**: Code is implemented to count the occurrence of each k-mer in each sequence as in:

  Φ_u^p (s)=|{〖(v〗_1,v_2 ) ∶ s= v_1 u〖 v〗_2 }|![image](https://github.com/amyfrancis97/DrivR-Base/assets/68270793/3399c62e-ba9d-43b4-adb3-aa3116c255b7)


* **Derivation of a P-spectra Kernel**: Utilizing the mapping function, a p-spectrum kernel matrix is derived by summing the products of corresponding row entries for the two sequences.

## Conclusion
We calculated p-spectra for different sequence lengths (xyz) and k-mer sizes (abc) based on the requirements of our analysis.
By analysing the p-spectra matrices, we captured the similarities and dissimilarities between sequences, considering the patterns of k-mers of various sizes. This approach provided valuable insights into the sequence variations induced by the variants and their potential impact on the overall sequence structure.

  
