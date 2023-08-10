# FG3_dinucleotide_properties

## Introduction and Overview
**FG3_dinucleotide_properties** is a module within the **DrivR-Base** framework designed to analyze the effects of genetic variants on dinucleotide properties. This module enables the exploration of 125 thermodynamic, structural, and other dinucleotide properties by querying variant sequences against a comprehensive dinucleotide property database. The module facilitates the extraction of meaningful insights into the impact of variants on nucleotide interactions.

## Directory Structure
```bash
DrivR-Base/
|-- FG3_dinucleotide_properties/
|   |-- 1_get_dinuc_properties.sh
|   |-- config.R
|   |-- module_dependencies.sh
|   |-- package_dependencies.R
|   |-- dinucleotide_properties.R
|   |-- dinucleotidePropertyTable.csv
```
## Packages and Dependencies
Efficient management of packages and dependencies is ensured through the following files:

* **module_dependencies.sh**:  Facilitates the handling of module-specific dependencies, ensuring a seamless and consistent environment.
* **package_dependencies.R**: Manages the installation and maintenance of required R packages.
* **config.R**: Configures the directory location of the essential **dinucleotidePropertyTable.csv** file.

## Prerequisite data
To initiate the script successfully, you must initially download the dinucleotidePropertyTable.csv file, which contains the dinucleotide property table for querying purposes. The table, sourced from [DiProDB](https://diprodb.fli-leibniz.de/ShowTable.php), encompasses 125 diverse thermodynamic, structural, and other dinucleotide properties.

## Script Usage
The core script driving this module is dinucleotide_properties.R. Here's an overview of the process it undertakes:

1. **Variant Query and Sequence Extraction**: The script queries the provided variant against the Hsapiens GRCh38 genome using the getFasta function. This operation yields both wild-type and mutant sequences, each spanning three base pairs.
2. **Dinucleotide Property Query**: Using the acquired 3-base pair sequences, the script performs queries against the dinucleotide property database. For instance, given a wild-type sequence "ATG" and a mutant sequence "AGG", four dinucleotides are queried: Wild-type-1 (1): "AT", Wild-type-2 (2): "TG", mutant-1 (3): "AG", mutant-2 (4): "GG".
3. **Output Representation**: The script generates an output table, where each row corresponds to a variant of interest. Columns encompassing 500 entries (125 properties x 4 dinucleotide queries) provide the dinucleotide property values for each respective query.

## Conclusion
By employing the FG3_dinucleotide_properties module, researchers gain the ability to comprehensively assess the impact of genetic variants on diverse dinucleotide properties. This module streamlines the querying and analysis process, paving the way for deeper insights into nucleotide interactions and their contributions to genetic variation.

For detailed instructions and examples on using the scripts, please refer to the respective script documentation.
