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
The output of the VEP cache query is a VCF file and all of the information is contained in the **INFO** field. It is necessary to reformat the file in order to create a more useable file format. Each of the separate reformatting python scripts are designed to reformat the corresponding output files. The following documentation gos into more detail on the individual scripts used here.

### reformat_vep_aa.py

Querying the cache for amino acid prediction gives the following formatted file:

| #CHROM |   POS  |   ID   | REF | ALT | QUAL | FILTER |     INFO    |
| ------ | ------ | ------ | --- | --- | ---- | ------ | ----------- |
|  chr1  | 935778 | 935778 |  C  |  T  |   1  |    1   | CSQ=D,D,D,D |
|  chr1  | 935785 | 935785 |  C  |  A  |   2  |    1   | CSQ=L/I,L/I |

The info field contains the query results for the variants of interest. The commas separate results for individual transcripts. In the case of amino acids, we can ignore everything after the first comma in the info field. The **reformat_vep_aa.py** script extracts everything after the "CSQ=" and the first "," in the INFO field. If there is only one amino acid, the variant is predicted to be synonymous, so the script assigns both the wild type and mutant amino acid as the single letter extracted. In the case of two amino acids separated by a "/", then the first amino acid is the predicted wild type, and the second is the predicted mutant. This is repeated for every variant to produce the following table:

| chrom |   pos  |  ref_allele | alt_allele |  R  | driver_stat | WT_AA | mutant_AA |
| ----- | ------ | ----------- | ---------- | --- | ----------- | ----- | --------- |
|  chr1 | 935778 |      C      |      T     |  1  |      1      |   D   |      D    |
|  chr1 | 935785 |      C      |      A     |  2  |      1      |   L   |      I    |

Finally, we convert this into one-hot-encoding, where each column represents the amino acid (WT and mutant), and the corresponding row will either be a "0" if not predicted, and "1" if predicted. For example:

| chrom |   pos  |  ref_allele | alt_allele |  R  | driver_stat | WT_D | WT_L | mutant_D | mutant_L |
| ----- | ------ | ----------- | ---------- | --- | ----------- | ---- | ---- | -------- | -------- |
|  chr1 | 935778 |      C      |      T     |  1  |      1      |   1  |   0  |     1    |     0    |
|  chr1 | 935785 |      C      |      A     |  2  |      1      |   0  |   1  |     0    |     1    |

The script saves both the non-autoencoded and autoencoded tables.

### reformat_vep_aa.py
