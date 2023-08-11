# FG8_aa_properties

## Introduction and Overview
The **FG8_aa_properties** dataset provides three distinct groups of physicochemical properties: "Cruciani," "Fasgai," and "Kidera," in addition to all properties listed in the "AAindex."

## Directory Structure
The directory structure is as follows:

```bash
DrivR-Base/
|-- FG8_aa_properties
|   |-- 1_get_aa_properties.sh
|   |-- extract_aa_properties.R
|   |-- package_dependencies.R
|   |-- AAindex.rda
```

## Packages and Dependencies
All required package dependencies are effectively managed through the **package_dependencies.R** script.

## Prerequisite Data
Before getting started, it's essential to load the amino acid properties from the [Amino Acid Index Database](https://academic.oup.com/nar/article/28/1/374/2384334) into your workspace. The provided R data file is named **AAindex.rda**, and it can be found in this directory. Alternatively, you can also download the dataset from the [AASea GitHub repository](https://github.com/cran/aaSEA/blob/master/data/AAindex.rda). Once downloaded, ensure that the data file and location is updated in the **config.R** file.

## Script Usage
The primary script for utilizing this dataset is **extract_aa_properties.R**. This script facilitates queries of vep-predicted amino acids against the **AAindex.rda** database, enabling you to access the physicochemical properties associated with each amino acid.

## Conclusions
In conclusion, the **FG8_aa_properties** dataset offers a comprehensive collection of physicochemical properties for amino acids, grouped under "Cruciani," "Fasgai," "Kidera," and the broader "AAindex." By leveraging the provided scripts and data files, researchers and analysts can gain valuable insights into the diverse physicochemical characteristics of amino acids, contributing to a deeper understanding of their roles and behaviors within biological systems.
