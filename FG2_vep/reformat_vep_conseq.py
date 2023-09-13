# Import packages
import pandas as pd
import os
import re
from textwrap import wrap
import numpy as np
import sys
from functools import reduce

# Check if this script is being executed as the main program
if __name__ == "__main__":
    # Read command-line arguments
    variants = sys.argv[2]  # Path to the variant file
    outputDir = sys.argv[1]  # Output directory

    # List of consequences of variants
    consequences = [
        # List of variant consequences (e.g., "splice_acceptor_variant", "missense_variant", etc.)
            "splice_acceptor_variant",
        "splice_donor_variant",
        "stop_gained",
        "frameshift_variant",
        "stop_lost",
        "start_lost",
        "transcript_amplification",
        "feature_elongation",
        "feature_truncation",
        "inframe_insertion",
        "inframe_deletion",
        "missense_variant",
        "protein_altering_variant",
        "splice_donor_5th_base_variant",
        "splice_region_variant",
        "splice_donor_region_variant",
        "splice_polypyrimidine_tract_variant",
        "incomplete_terminal_codon_variant",
        "start_retained_variant",
        "stop_retained_variant",
        "synonymous_variant",
        "coding_sequence_variant",
        "mature_miRNA_variant",
        "5_prime_UTR_variant",
        "3_prime_UTR_variant",
        "non_coding_transcript_exon_variant",
        "intron_variant",
        "NMD_transcript_variant",
        "non_coding_transcript_variant",
        "coding_transcript_variant",
        "upstream_gene_variant",
        "downstream_gene_variant",
        "TFBS_ablation",
        "TFBS_amplification",
        "TF_binding_site_variant",
        "regulatory_region_ablation",
        "regulatory_region_amplification",
        "regulatory_region_variant",
        "intergenic_variant",
        "sequence_variant"
    ]

    chunksize = 50000
    # Process the variant data in chunks (50000 rows at a time)
    for df in pd.read_csv(variants + "variant_effect_output_conseq.txt", sep="\t", skiprows=4, chunksize=chunksize):
        # Replace '&' with ',' in the 'INFO' column
        df = df.replace("&", ",", regex=True)

        # Extract information from the 'INFO' column into a new DataFrame
        df2 = df.INFO.str.split(",", expand=True).iloc[:, 1:]
        df2 = df2.fillna(value=np.nan)
        df2 = df2.replace("", np.nan)

        # Initialize an empty list to store data for each row
        df3 = []
        for x in range(0, len(df)):
            # Create a DataFrame with the first 7 columns of the original DataFrame (df)
            data = pd.DataFrame(df.iloc[x, :7]).transpose()
            # Add columns for each consequence in the 'consequences' list
            data = data.reindex(columns=data.columns.tolist() + consequences)
            
            # Populate the new consequence columns with 1 where applicable based on 'df2'
            for i in df2.iloc[x, :].unique():
                data[i] = 1
            
            # Append the row DataFrame to the list
            df3.append(pd.DataFrame(data))
        
        # Concatenate all the row DataFrames into a single DataFrame
        df3 = pd.concat(df3)
        
        # Fill any NaN values with 0
        df3 = df3.fillna(0)
        
        # Drop the 'ID' column and rename columns for clarity
        df3 = df3.drop(["ID"], axis=1)
        df3 = df3.rename(columns={"#CHROM": "chrom", "POS": "pos", "REF": "ref_allele", "ALT": "alt_allele", "QUAL": "R", "FILTER": "driver_stat"})
        
        # Round the numeric columns to two decimal places
        df3 = df3.round(2)
        df3 = df3.drop(["R", "driver_stat"], axis = 1)        
        # Save the processed DataFrame to a TSV file
        file_path = outputDir + "vepConsequences.bed"
        if os.path.exists(file_path):
            df3.to_csv(file_path, header=None, index=None, sep="\t", mode='a')
        else:
            df3.to_csv(file_path, index=None, sep="\t")


