# FG1_conservation

## Introduction and Overview

```bash
DrivR-Base/
|-- FG1_conservation/
|   |-- 1_reformat.sh
|   |-- 2_download_cons_features.sh
|   |-- 3_query_cons_features.sh
|   |-- check_formatting.py
|   |-- download_convert.job
|   |-- module_dependencies.sh
|   |-- package_dependencies.py
```
## Packages and Dependencies
All packages and dependencies are listed and called in the **module_dependencies.sh** and **package_dependencies.py** scripts. Most importantly, *bedtools* must be installed in order for the *bigWigToBedGraph* command to work in the **download_convert.job** script.

## Script Usage
### 1_reformat.sh
This script reformats the variant file to match that in the UCSC sequence conservation files. Specifically, the position columns are altered from pos, pos to pos, pos-1.
For example, the script converts this variant:

| Chromosome | Position | Position | Reference Allele | Alternate Allele | Recurrence | Driver Status |
| ---------- | -------- | -------- | ---------------- | ---------------- | ---------- | ------------- |
|    chr1    |  934881  |  934881  |        A         |         G        |      1     |       1       |

Into the following format:

| Chromosome | Position | Position | Reference Allele | Alternate Allele | Recurrence | Driver Status |
| ---------- | -------- | -------- | ---------------- | ---------------- | ---------- | ------------- |
|    chr1    |  934880  |  934881  |        A         |         G        |      1     |       1       |

This is done to get exact value matches when querying using the bedtools_intersect command.

### 2_download_cons_features.sh & download_convert.job
These scripts are used to download all of the available conservation and uniqueness files available in the UCSC genome browser and converts them from bigWig to bedGraph format. 
The **2_download_cons_features** script submits the **download_convert.job** as a separate batch job for each possible feature. The **download_convert.job** script then downloads the file, and then converts the file to bedGraph format using the *bigWigToBedGraph* command in *bedtools*.

### check_formatting.py
In case of any issues with tab-separated formatting in the converted bed file, simple import the data into python and export it again as a tab-separated file. Sometimes tab formatting can be disrupted during the conversion process.
