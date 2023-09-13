# FG6: Amino Acid Substitution Matrices

## Introduction
The **FG8_aa_properties** dataset provides three distinct groups of physicochemical properties: "Cruciani," "Fasgai," and "Kidera," in addition to all properties listed in the "AAindex."

## Installation and Dependencies
Please configure the required packages for this module in the top-level directory **/DrivR-Base**. Importantly, make sure that the anaconda environment is loaded properly.

## Prerequisites
Before getting started, its essential to load the amino acid properties from the [Amino Acid Index Database](https://academic.oup.com/nar/article/28/1/374/2384334) into your workspace. The provided R data file is named **AAindex.rda**, and it can be found in this directory. Alternatively, you can also download the dataset from the [AASea GitHub repository](https://github.com/cran/aaSEA/blob/master/data/AAindex.rda). O

## Usage

### `extract_aa_properties.R`
This script facilitates queries of vep-predicted amino acids against the **AAindex.rda** database, enabling you to access the physicochemical properties associated with each amino acid.

### Script execution
To execute the script, navigate to the /FG3_dna_shape directory and run:

```bash
RENVCMD="renv::activate(\"$renv_dir/renv.lock\")"
Rscript extract_aa_properties.R $variantDir $variantFileName $outputDir
```

* $renv_dir: Location of the renv.lock file (within /DrivR-Base folder)
* $variantDir: Location of the variant file (ends with /).
* $variantFileName: Name of the variant file.
* $outputDir: Location to store the resulting file (ends with /).

## Conclusion
In conclusion, the **FG8_aa_properties** dataset offers a comprehensive collection of physicochemical properties for amino acids, grouped under "Cruciani," "Fasgai," "Kidera," and the broader "AAindex." By leveraging the provided scripts and data files, researchers and analysts can gain valuable insights into the diverse physicochemical characteristics of amino acids, contributing to a deeper understanding of their roles and behaviors within biological systems. For detailed instructions and examples on using the scripts, please refer to the respective script documentation.


