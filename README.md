# DrivR-Base

## Introduction and Overview
Welcome to DrivR-Base! This repository contains scripts for extracting feature information from different databases for single nucleotide variants (SNVs). These features are designed to be inputs for machine learning models, aiding in the prediction of functional impacts of genetic variants in human genome sequencing. The repository is organized into separate sub-directories for different feature groups (**FG_**), each serving a unique purpose. Please note that these scripts are only set up to analyse autosomal variants in the GRCh38 genome format.

## Table of Contents
- [Introduction and Overview](#introduction-and-overview)
- [Table of Contents](#table-of-contents)
- [Feature Descriptions and Sources](#feature-descriptions)
- [Data Input Structure](#data-input-structure)
- [Dependencies](#dependencies)
- [Package Installation](#package-installation)
- [R Environment Setup with renv](renv-setup)
- [Python Environment Setup with Anaconda](anaconda-setup)
- [Directory Structure](#directory-structure)
- [Feature Description & Usage](#feature-description--usage)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Contact](#contact)

## Feature Descriptions and Sources

| Feature Group Label |                                             Feature Group Description                                            |                          Source                         |
| ------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
|         FG1         | 20 sequence conservation and uniqueness features from UCSC genome browser, including PhyloP and PhastCons scores | [UCSC](http://hgdownload.cse.ucsc.edu/goldenpath/hg38/) |
|         FG2         | 3 Variant Effect Predictor features, including amino acid prediction, consequences, and distances to transcripts | [VEP Cache](https://www.ensembl.org/info/docs/tools/vep/script/vep_cache.html) |
|         FG3         | 125 dinucleotide properties for wild-type and mutant nucleotide sequences                                        | [DiProGB](https://diprodb.fli-leibniz.de/ShowTable.php) |
|         FG4         | 5 DNA shape properties, including electrostatic potential and minor groove width                                 | [DNAshapeR](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4824130/) |
|         FG5         | GC-content and CpG counts for various window sizes                                                               | [Self-calculated](https://github.com/amyfrancis97/DrivR-Base/blob/main/FG5_gc_CpG/get_gc_CpG.py)
|         FG6         | Kernel-based DNA sequence similarity scores for wild-type and mutant sequences                                   | [Self-calculated](https://github.com/amyfrancis97/DrivR-Base/blob/main/FG6_kernel/get_kernel.py) |
|         FG7         | scores for 13 different amino acid substitution matrices                                                         | [Bio2mds](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3403911/) |
|         FG8         | 533 amino acid properties for both wild-type and mutant amino acids                                              | [AAindex](https://academic.oup.com/nar/article/28/1/374/2384334?login=false) |
|         FG9         | Results for 10 different ENCODE assays, including transcription factor binding sites and histone modifications   | [ENCODE](https://www.encodeproject.org/)
|         FG10        | AlphaFold structural conformation and atom properties at the predicted amino acid site                           | [AlphaFold](https://alphafold.ebi.ac.uk/)


## Data Input Structure
All variant files must be presented in the BED format shown in the following table but **should not contain any headers**:

| Chromosome |  Start   |    End   | Reference Allele | Alternate Allele | 
| ---------- | -------- | -------- | ---------------- | ---------------- | 
|    chr1    |  934881  |  934881  |        A         |         G        | 

Importantly, the chromosomal position must exist in a string format with a prefix of "chr", and the positions must be in an integer format. Crucially, the chromosomal position **must** be in the GRCh38 reference genome format. All features are extracted and queried using these descriptors, if the variant is provided in the wrong reference genome, the feature information will be incorrect. An example variant file in the correct format can be found in the **/example** directory.

## Dependencies and Installation
The scripts in this repository require a range of dependencies.

## Dependencies

- [Bedtools](https://github.com/arq5x/bedtools2)
- [Bedops](https://github.com/bedops/bedops)
- [Samtools](https://github.com/samtools/samtools)
- [Bcftools](https://github.com/samtools/bcftools)
- [Tabix](https://github.com/samtools/tabix)
- [Htslib](https://github.com/samtools/htslib)
- [Anaconda](https://www.anaconda.com/products/distribution)
- [Git](https://git-scm.com/)
- [Perl](https://www.perl.org/)

## Package Installation

To install the required packages, use the appropriate package manager for your system:

- **On Ubuntu/Debian:**

  ```bash
  sudo apt-get install bedtools samtools bcftools tabix libhts-dev
  ```

- **On CentOS/RHEL:**

  ```bash
  sudo yum install bedtools samtools bcftools tabix htslib-devel
  ```

- **On macOS (using Homebrew):**

  ```bash
  brew install bedtools samtools bcftools tabix htslib
  ```

### **Anaconda Setup:**
If Anaconda is not already installed on your system, you can download and install Anaconda from the official Anaconda website: https://www.anaconda.com/products/distribution

These commands will install all the necessary packages for your project. Make sure you have the appropriate package manager installed on your system.

### **Git Setup:**
If you haven't already, make sure you have Git installed on your system. You can download and install Git from the official website: https://git-scm.com/

### **Perl Modules Installation:**
To install the required Perl modules, follow these steps:

  1) Install cpanminus (App::cpanminus):
  
      ```bash
      curl -L https://cpanmin.us | perl - App::cpanminus
      ```
  
  2) Set up local::lib:
  
      ```bash
      cpanm --local-lib=~/perl5 local::lib
      eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
      ```
  
  3) Install the Perl modules:
  
      ```bash
      cpanm Archive::Zip
      cpanm DBD::mysql
      cpanm DBI
      ```

These commands will install the required Perl modules for your project.

## R Environment Setup with renv

The R environment for this project has been set up using [renv](https://rstudio.github.io/renv/articles/renv.html). The relevant packages and versions can be found in the `renv.lock` file.

To activate the `renv` environment before executing any R script, use the following command in the command prompt:
  
  ```bash
  RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"
  ```

Where $renv_dir is the directory in which the renv.lock file is located.

## Python Environment Setup with Anaconda
To set up the Anaconda environment for this project, follow these steps:

1. Once Anaconda is installed on your system, navigate to the **/DrivR-Base** directory in your project.

2. Run the **conda_setup.sh** script to build the Conda environment using the **DrivR-Base.yml** file:

    ```bash
    ./conda_setup.sh
    ```
    
After running the script, the Conda environment named "DrivR-Base" will be created, and the required packages will be installed. You can activate the Conda environment anytime you work on your project using:

  ```bash
  conda activate DrivR-Base
  ```

## Directory Structure
```bash
DrivR-Base/
|-- FG1_conservation/
|   |-- get_conservation.sh
|   |-- check_formatting.py
|   |-- config.sh
|   |-- README.md
|
|-- FG2_vep/
|   |-- get_vep.sh
|   |-- reformat_vep_aa.py
|   |-- reformat_vep_conseq.py
|   |-- reformat_vep_distance.py
|   |-- config.sh
|   |-- README.md
|
|-- FG3_dinucleotide_properties/
|   |-- dinucleotide_properties.R
|   |-- dinucleotidePropertyTable.csv
|   |-- config.R
|   |-- README.md
|
|-- FG4_dna_shape/
|   |-- dna_shape.R
|   |-- config.R
|   |-- README.md
|
|-- FG5_gc_CpG/
|   |-- get_gc_CpG.py
|   |-- config.py
|   |-- README.md
|
|-- FG6_kernel/
|   |-- get_kernel.py
|   |-- config.py
|   |-- README.md
|
|-- FG7_aa_substitution_matrices/
|   |-- aa_subs_matrices.R
|   |-- config.sh
|   |-- README.md
|
|-- FG8_aa_properties
|   |-- extract_aa_properties.R
|   |-- AAindex.rda
|   |-- config.R
|   |-- config.sh
|   |-- README.md
|
|-- FG9_encode/
|   |-- get_encode.sh
|   |-- downloadEncode.py
|   |-- addAnnotations.py
|   |-- reformat_encode.py
|   |-- config.sh
|   |-- README.md
|
|-- FG10_alpha_fold/
|   |-- get_alpha_fold.py
|   |-- README.md
```

## Feature Description & Usage
For individual feature descriptions and usage, please see the documentation within the relevant sub-directory.

## Contributing
Contributions are welcome! Follow the guidelines in CONTRIBUTING.md

## License
This project is licensed under [LICENSE](https://github.com/amyfrancis97/DrivR-Base/blob/main/LICENSE).

## Acknowledgments
This work was carried out in the UK Medical Research Council Integrative Epidemiology Unit (MC\_UU\_00032/03) and using the computational facilities of the Advanced Computing Research Centre, University of Bristol.

Special thanks to:
* Tom Gaunt
* Colin Campbell

## Funding
This work was funded by Cancer Research UK [C18281/A30905]. 

## Contact
For inquiries, contact us at [amy.francis@bristol.ac.uk](mailto:amy.francis@bristol.ac.uk).


