# FG1: Conservation-based features

## Introduction and Overview
The **FG1_conservation** module is designed to facilitate the reformatting, downloading, and conversion of conservation and uniqueness files from the UCSC genome browser. It includes a set of scripts and resources to streamline the process.

## Packages and Dependencies
The instructions to configure packages for this module can be found in the top-level directory **/DrivR-Base**.

Make sure to have the necessary dependencies installed, including the critical requirement for the *bedtools* package, which is essential for executing the *bigWigToBedGraph* command.

## Script Description
### get_conservation.sh
This script first reformats the variant input file to match that in UCSC. The *check_formatting.py* script fixes any possible formatting issues that might occur during this process. Next, it downloads the 22 conservation and mappability datasets from the UCSC golden path. The names of these datasets can be found within the script. **Please note that this script downloads all conservation data locally for querying and will temporarily require approximately 1TB of space**. Hence, ensure that the *download_cons_dir* in the *config.sh* file is updated to a location that has enough space to store these files. Once downloaded, the script will convert the files from *.bigwig* to *.bedGraph* format and then will query the resulting files against the provided input variants.

### Script input
The variant file must follow the guidelines stated in the **/DrivR-Base** .README file. It should be in **.BED** format, separated by tab-delimited spaces. The chromosome should be in string format, proceeded by *"chr"*:

| Chromosome | Position | Position | Reference Allele | Alternate Allele | Recurrence | Driver Status |
| ---------- | -------- | -------- | ---------------- | ---------------- | ---------- | ------------- |
|    chr1    |  934881  |  934881  |        A         |         G        |      1     |       1       |


Please refer to the example **variant.bed** file in the **/DrivR-Base/Example** folder for more information.

### Script execution
In order to execute this script, simply navigate to the directory in which the **/FG1_conservation** module is located and execute the run command:

```bash
./get_conservation.sh $variantDir $variantFileName $outputDir
```

Where *$variantDir* is the location in which the variant file is located and must end with a */*, *$variantFileName* is the name of the variant file, and $outputDir is the location in which you wish to store the resulting file associated with your variants (this must also end with a */*.

### Conclusion
The FG1_conservation module simplifies the process of reformatting, downloading, and converting conservation and uniqueness files, contributing to a more efficient workflow for genomic analysis.
