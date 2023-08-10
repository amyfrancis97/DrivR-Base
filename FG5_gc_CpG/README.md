# FG5_gc_CpG

## Introduction and Overview
The **FG5_gc_CpG** module is designed to calculate and analyze GC content and CpG-related features within nucleotide windows for given variants. By querying the human GRCh38 genome, this script enables the extraction of relevant sequence information and the calculation of essential molecular properties.

## Directory Structure
```bash
DrivR-Base/
|-- FG5_gc_CpG/
|   |-- 1_get_gc_CpG.sh
|   |-- get_gc_CpG.py
|   |-- packages_dependencies.py
```

## Packages and Dependencies
The module relies on the following package for efficient dependency management:

* **package_dependencies.py*: Organizes the installation and maintenance of essential Python packages.

## Prerequisite data
Before running the script, ensure you have the human genome in GRCh38 fasta format for accurate querying of nucleotide windows. The genome can be downloaded from [NCBI](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.26/). To proceed, update the "hg38_seq" variable in the config.py file to specify the path to your downloaded genome.

## Script Usage
The primary script, get_gc_CpG.py, carries out the following steps:

* **Variant Query and Sequence Extraction**: Similar to the approach used in the **FG3_dinucleotide_properties** and **FG4_dna_shape modules**, this script queries the GRCh38 genome for provided variants within a specified window size. Unlike the other scripts, this Python script requires the pre-downloaded GRCh38 genome for accurate querying. Make sure to update the "hg38_seq" variable in config.py before running the script.

* **Calculation of GC Content, CpG Count, and CpG Observed/Expected Ratio**: The script calculates GC content using the formula (wildType.count("G") + wildType.count("C")) / len(wildType) * 100. Additionally, CpG count is computed with wildType.count("CG"), and CpG observed/expected ratio is calculated using (CpGCount * len(wildType)) / (wildType.count("G") * wildType.count("C")).

## Conclusion
The **FG5_gc_CpG** module provides a powerful tool for extracting and analyzing nucleotide sequences, contributing to a deeper understanding of GC content and CpG-related features within the context of genetic variants. By leveraging the GRCh38 genome and executing comprehensive calculations, this module facilitates valuable insights into molecular properties.

For detailed instructions and usage examples, refer to the scripts and dependencies listed in the directory structure above.
