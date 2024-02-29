# FG9: ENCODE features

## Introduction
ENCODE offers a wealth of functional information about the human genome. Here, we extract we extract eight features potentially informative for variant pathogenicity:

* Transcription Factor ChIP-seq
* Histone ChIP-seq
* DNase-seq
* Mint-ChIP-seq
* ATAC-seq
* eCLIP
* ChIA-PET
* GM DNase-seq

## Installation and Dependencies
Please configure the required packages for this module in the top-level directory **/DrivR-Base**. Importantly, make sure that the anaconda environment is loaded properly.

## Usage

### `get_encode.sh`
This script executes each of the following steps to extract encode features for given variants:

1) Submits the `downloadEncode.py` script which downloads every possible encode file for the above 8 features
2) Converts the files from .bigBed to .bed and concatenates them into a single file for each feature group. 
3) Submits the `addAnnotations.py` script which annotates the feature files with accession numbers, target types (e.g., transcription factors), biosamples, and peak types.
4) Querys the annotated feature file against the variant file submited.
5) Submits the `reformat_encode.py` script to reformat the resulting file for input into models. This script extracts crucial data such as signal values, p-values, q-values, and peaks for each variant. For cases with multiple peaks, such as when replicate assays are involved, we also record minimum, maximum, mean, and range values.

### Script execution
To execute the script, navigate to the /FG9_encode directory and run:

```bash
./get_encode.sh $variantDir $variantFileName $outputDir
```

* $renv_dir: Location of the renv.lock file (within /DrivR-Base folder)
* $variantDir: Location of the variant file (ends with /).
* $variantFileName: Name of the variant file.
* $outputDir: Location to store the resulting file (ends with /).

## Conclusion
By integrating the ENCODE data into the analysis, it is possible to capture the functional elements and regulatory information associated with each variant. 
