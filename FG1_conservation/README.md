# FG1_conservation

## Introduction and Overview
The **FG1_conservation** module is designed to facilitate the reformatting, downloading, and conversion of conservation and uniqueness files from the UCSC genome browser. It includes a set of scripts and resources to streamline the process.

## Packages and Dependencies
All required packages and dependencies are managed in the following files:

* **module_dependencies.sh**: Manages module-specific dependencies.
* **package_dependencies.py**: Lists and manages Python package dependencies.

Make sure to have the necessary dependencies installed, including the critical requirement for the *bedtools* package, which is essential for executing the *bigWigToBedGraph* command in the **download_convert.job** script.

## Script Usage
### 1_reformat.sh
This script restructures the variant file to align with the format used in UCSC sequence conservation files. It adjusts the position columns to ensure accurate value matching during subsequent queries. To run the script, execute the following command in the terminal prompt:

```bash
variant_file_location="/users/name/dir/"
variant_file_name="variants.bed"
./1_reformat.sh $variant_file_location $variant_file_name
```

The **variant_file_location** must end with a "/" and the variant file should be tab-delimited and should comply with the following extended bed formatting:

| Chromosome | Position | Position | Reference Allele | Alternate Allele | Recurrence | Driver Status |
| ---------- | -------- | -------- | ---------------- | ---------------- | ---------- | ------------- |
|    chr1    |  934881  |  934881  |        A         |         G        |      1     |       1       |

The script will then reformat the positions in the file to match those in the UCSC conservation files:

| Chromosome | Position | Position | Reference Allele | Alternate Allele | Recurrence | Driver Status |
| ---------- | -------- | -------- | ---------------- | ---------------- | ---------- | ------------- |
|    chr1    |  934880  |  934881  |        A         |         G        |      1     |       1       |


### 2_download_cons_features.sh & download_convert.job
These scripts collaboratively automate the download and conversion of conservation and uniqueness files from the UCSC genome browser.

* **2_download_cons_features.sh**: Initiates batch jobs for each available feature using the **download_convert.job** script.
* **download_convert.job**: Downloads and converts files from bigWig to bedGraph format utilizing the *bigWigToBedGraph* command within *bedtools*.

To execute this script, simply run the following command in your terminal:

```bash
./2_download_cons_features.sh
```

### check_formatting.py
In situations where tab-separated formatting issues arise during the conversion of bed files, this Python script provides a quick solution. By importing the data and re-exporting it as a tab-separated file, this script mitigates potential disruptions in tab formatting that may occur during the conversion process.

### Conclusion
The FG1_conservation module simplifies the process of reformatting, downloading, and converting conservation and uniqueness files, contributing to a more efficient workflow for genomic analysis.
