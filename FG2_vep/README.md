# FG2_vep

## Introduction and Overview
**FG2_vep** is a module within the **DrivR-Base** framework that provides a comprehensive toolkit for Variant Effect Prediction (VEP) analysis. It streamlines the process of downloading VEP cache, querying variants against the cache, and reformatting the query results. The module includes a set of scripts and resources to simplify and accelerate VEP analysis tasks.

## Directory Structure
```bash
DrivR-Base/
|-- FG2_vep/
|   |-- 1_download_vep.sh
|   |-- 2_query_vep.sh
|   |-- 3_reformat_vep_res.sh
|   |-- module_dependencies.sh
|   |-- query_vep.sh
|   |-- reformat_vep.sh
|   |-- reformat_vep_aa.py
|   |-- reformat_vep_conseq.py
|   |-- reformat_vep_distance.py
```
## Packages and Dependencies
All required packages and module dependencies are organized and managed within the following files:
* **module_dependencies.sh**: Manages module-specific dependencies, ensuring a smooth and consistent environment.
* **1_download_vep.sh**:  Installs and manages the VEP cache. Note that this process involves a range of dependencies; refer to the [VEP website and tutorial](https://www.ensembl.org/info/docs/tools/vep/script/vep_download.html#installer). for detailed instructions.

## Script Usage

### 2_query_vep.sh
This script initiates the VEP analysis by downloading the GRCh38 genome version from the VEP cache. It then submits the query_vep.sh script to perform the actual queries against the cache. The query_vep.sh script conducts four distinct queries to extract crucial information from the VEP cache.

1. **Protein Uniprot Predictions**: Queries protein predictions that play a role in subsequent **FG10_alpha_fold** scripts.
2. **Consequence Features**: Queries predictions about the impact of a variant on each transcript. Different consequence outputs are detailed on the [VEP consequence web page](https://www.ensembl.org/info/genome/variation/prediction/predicted_data.html).
3. **Amino Acid Effects**: Extracts amino acid predictions, including wild-type and mutant amino acids, from variants.
4. **Distance Features**: Captures distances between a variant and specific transcripts.

### 3_reformat_vep_res.sh
The VEP cache query results are stored in VCF files, with information concentrated in the **INFO** field. To enhance usability, the reformatting process is introduced through Python scripts.

### reformat_vep_aa.py

This script processes amino acid prediction data obtained from the cache query. It extracts relevant information from the INFO field, including wild-type and mutant amino acids for each variant. The script then performs one-hot encoding, creating a compact representation of amino acid predictions for further analysis.

### reformat_vep_conseq.py
For consequence predictions, this script extracts and compiles unique consequence features for each variant. It creates a one-hot-encoded table, simplifying downstream analysis by indicating the presence or absence of specific consequences.

### reformat_vep_distance.py
To analyze distance features, this script calculates the minimum, maximum, and mean distances between a variant and its associated transcripts. It leverages the INFO field to gather these insights, facilitating a comprehensive understanding of variant effects.

## Conclusion
The FG2_vep module empowers users with a comprehensive toolkit for Variant Effect Prediction analysis. By automating key steps in the VEP workflow and facilitating data reformatting, this module contributes to a more efficient and insightful genomic analysis process.

For detailed usage instructions and examples, please refer to the individual script documentation.

