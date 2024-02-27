# Import necessary packages
import pandas as pd
import os
import re
from textwrap import wrap
import numpy as np
import sys
from functools import reduce

# Check if the script is being run as the main program
if __name__ == "__main__":
    # Define file paths and output directory
    variants = sys.argv[2]  # Path to the variant file
    outputDir = sys.argv[1]  # Output directory

    # Initialize lists and variables
    all_regions = []
    chunksize = 5000

    # Initialize an empty list for merging DataFrames
    merged_df = []

    # Process the variant data in chunks (2 rows at a time)
    for df in pd.read_csv(variants + "variant_effect_output_AA.txt", sep="\t", chunksize=chunksize):
        print(df.head())
        df = df.reset_index(drop=True)

        # Define the regular expression pattern to split INFO column
        pattern = r"[,=]"

        # Use re.split() to split INFO column based on the pattern
        list_res = [re.split(pattern, df["INFO"][i]) for i in range(0, len(df))]
        df2 = pd.DataFrame(list_res).drop(0, axis=1)

        # Initialize a list to store rows
        rows = []

        # Iterate through each row
        for row_index in range(0, len(df)):

            # Function to check if an element is a non-empty string
            def is_non_empty_string(element):
                return isinstance(element, str) and element != ''

            # Apply the is_non_empty_string function to each element in the specified row
            row_contains_string = df2.iloc[row_index].apply(is_non_empty_string)

            # Get the column names where the row contains a string
            columns_with_string = row_contains_string[row_contains_string].index.tolist()

            # Create a new DataFrame row
            row = pd.DataFrame(df.iloc[row_index, :]).transpose()

            # Check if there are no columns with strings
            if len(columns_with_string) == 0:
                row["WT_AA"] = np.nan
                row["mutant_AA"] = np.nan
            else:
                # Split the AA string based on '/'
                AA = df2.iloc[row_index, :][columns_with_string[0]].split("/")

                if len(AA) == 1:
                    row["WT_AA"] = AA
                    row["mutant_AA"] = AA
                else:
                    row["WT_AA"] = AA[0]
                    row["mutant_AA"] = AA[1]

            # Append the row to the list of rows
            rows.append(row)

        # Concatenate the rows and drop unnecessary columns
        df_fin = pd.concat(rows).drop(["QUAL", "FILTER", "INFO", "ID"], axis=1)
        merged_df.append(df_fin)

    # Concatenate DataFrames from chunks into a final DataFrame
    final_df = pd.concat(merged_df)

    # Rename columns for clarity
    final_df = final_df.rename(columns={"#CHROM": "chrom", "POS": "pos", "REF": "ref_allele", "ALT": "alt_allele"})

    # Save the processed DataFrame to a TSV file
    file_path = outputDir + "vepAA.bed"
    final_df.to_csv(file_path, index=None, sep="\t")

    # Convert 'WT_AA' and 'mutant_AA' columns to one-hot encoded columns
    final_df = pd.get_dummies(final_df, columns=['WT_AA', 'mutant_AA'])
    final_df.iloc[:, 4:] = final_df.iloc[:, 4:].astype(int)
    # Fill missing values with 0 and save the final DataFrame to a TSV file
    final_df = final_df.fillna(0)
    file_path = outputDir + "vepAA_OHE.bed"
    final_df.to_csv(file_path, index=None, sep="\t")

