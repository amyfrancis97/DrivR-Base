from package_dependencies import *

if __name__ == "__main__":
    # Read command-line arguments
    variants = sys.argv[2]  # Path to the variant file
    outputDir = sys.argv[1]  # Output directory

    all_regions = []
    chunksize = 50000

    # Initialize the merged_df with None
    merged_df = []

    # Process the variant data in chunks (50000 rows at a time)
    for df in pd.read_csv(variants + "variant_effect_output_AA.txt", sep="\t", skiprows=4, chunksize=chunksize):
        # Extract relevant information from the 'INFO' column
        x = df["INFO"].str.split(",", expand=True)[0].str.split("=", expand=True)[1].str.split("/", expand=True)
        # Fill missing values in the second column with values from the first column
        x[1] = x[1].mask(x[1].isnull(), x[0])

        # Combine the extracted data with the original DataFrame
        df3 = pd.concat([df.iloc[:, :7], x], axis=1)
        # Drop the 'ID' column and rename the columns for clarity
        df3 = df3.drop(["ID"], axis=1)
        df3 = df3.rename(columns={"#CHROM": "chrom", "POS": "pos", "REF": "ref_allele", "ALT": "alt_allele", "QUAL": "R", "FILTER": "driver_stat", 0: "WT_AA", 1: "mutant_AA"})
        df3 = df3[(df3["ref_allele"].str.len() == 1) & (df3["alt_allele"].str.len() == 1) ]
        # Save the processed DataFrame to a TSV file
        file_path = outputDir + "vepAA.bed"
        if os.path.exists(file_path):
            df3.to_csv(file_path, header=None, index=None, sep="\t", mode='a')
        else:
            df3.to_csv(file_path, index=None, sep="\t")

        # Convert 'WT_AA' and 'mutant_AA' columns to one-hot encoded columns
        # One-hot encode the categorical columns 'WT_AA' and 'mutant_AA'
        df_encoded = pd.get_dummies(df3, columns=['WT_AA', 'mutant_AA'])
        # Display the resulting DataFrame
        print(df_encoded)
        merged_df.append(df_encoded)  # Append the processed DataFrame to the list

    # Merge DataFrames in the list
    data_merge = reduce(lambda left, right: pd.merge(left, right, how="left"), merged_df)
    for col in data_merge.columns.tolist()[7:]:
        data_merge[col] = data_merge[col].astype("Int64")
    # Fill missing values with 0 and save the final DataFrame to a TSV file
    data_merge = data_merge.fillna(0)
    file_path = outputDir + "vepAA_OHE.bed"
    data_merge.to_csv(file_path, index=None, sep="\t")
