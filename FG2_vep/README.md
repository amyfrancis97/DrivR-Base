# FG2_vep

## Introduction and Overview

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
All package and module dependencies are listed and called from the **module_dependencies.sh** and scripts. Most importantly, the VEP cache must first be downloaded in order for the scripts to work. All of the code required for installation of the VEP cache is described in **1_download_vep.sh**. Please note that there are a large number of dependencies required to install the cache. For more detailed information on this, please see the [VEP website and tutorial](https://www.ensembl.org/info/docs/tools/vep/script/vep_download.html#installer). 

## Script Usage

### 2_query_vep.sh
This script downloads the GRCh38 genome version from the VEP cache. It then submits the **query_vep.sh** script. The **query_vep.sh** script then queries the given variants against the human genome VEP cache. Specifically, it submits four queries. Firstly, it queries for protein uniprot predictions, which will be used further down the line in the **FG10_alpha_fold** scripts. It then queries the cache for consequence features. These are predictions on what the effect might be of a variant on each transcript. For more information on possible consequence outputs, please see the [VEP consequence web page](https://www.ensembl.org/info/genome/variation/prediction/predicted_data.html). Thirdly, we extract the amino acids that are predicted to be affected by the variant. More specifically, the output gives the predicted wild-type amino acid, and for a non-synonymous variant, the predicted mutant amino acid. Finally, we extract the distance features from VEP. This describes the distance between a variant and a particular transcript. The reason for four separate queries is that the output **INFO** column after querying the cache is extremely difficult to work with. It's much easier to do four separate queries (although it will take longer to run).

### 3_reformat_vep_res.sh
