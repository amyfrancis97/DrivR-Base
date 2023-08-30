import pandas as pd
import sys

# Define a function to process each variant
def getValues(variant):
    # Get the unique variant at the given index
    unique_variants = unique_variants_1.iloc[variant, :]

    # Filter the DataFrame to include only rows with matching variant values
    df2 = df[
        (df[16] == unique_variants[16]) &
        (df[17] == unique_variants[17]) &
        (df[18] == unique_variants[18]) &
        (df[19] == unique_variants[19]) &
        (df[20] == unique_variants[20]) &
        (df[21] == unique_variants[21]) &
        (df[22] == unique_variants[22])
    ]

    # Create a new DataFrame with a single row using the unique variant data
    final_df = pd.DataFrame(unique_variants).transpose().reset_index(drop=True)
    final_df.columns = ["chrom", "start", "pos", "ref_allele", "alt_allele", "R", "driver_stat"]

    # Iterate over unique 'target' values in column 12
    for target in df2[12].unique().tolist():
        # Filter rows with the current 'target' value
        df3 = df2[df2[12] == target]

        # Iterate over unique 'biosample' values in column 13
        for biosample in df3[13].unique().tolist():
            # Filter rows with the current 'target' and 'biosample' values
            df4 = df3[df3[13] == biosample]

            # Define a function to fill statistics for different value types
            def fillDf(valueType, column):
                final_df[f"{target}_{biosample}_{valueType}_min"] = round(df4[column].min(), 3)
                final_df[f"{target}_{biosample}_{valueType}_max"] = round(df4[column].max(), 3)
                final_df[f"{target}_{biosample}_{valueType}_mean"] = round(df4[column].mean(), 3)
                final_df[f"{target}_{biosample}_{valueType}_range"] = round(df4[column].max() - df4[column].min(), 3)

            # Calculate and fill statistics for various value types
            fillDf("signalValue", 6)
            fillDf("pValue", 7)
            fillDf("qValue", 8)
            fillDf("peak", 9)

    # Return the DataFrame with statistics for the current variant
    return final_df

if __name__ == "__main__":
    feature = sys.argv[1]
    inputDir = sys.argv[2]
    outputDir = sys.argv[3]

    # Read the CSV file into a DataFrame
    df = pd.read_csv(f"{inputDir}/{feature}.final.bed", header=None, sep="\t")

    # Extract unique variants by selecting columns 16 to 22 and dropping duplicates
    unique_variants_1 = df[range(16, 23)].drop_duplicates()

    # Create a result DataFrame by concatenating results for all variants
    res = pd.concat([getValues(variant) for variant in range(0, len(unique_variants_1))])
    res.to_csv(f"{outputDir}/{feature}.bed", sep = "\t", index = None)
