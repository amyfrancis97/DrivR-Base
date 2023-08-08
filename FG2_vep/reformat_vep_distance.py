from package_dependencies import *

# Check if this script is being executed as the main program
if __name__ == "__main__":
    # Read command-line arguments
    variants = sys.argv[2]  # Path to the variant file
    outputDir = sys.argv[1]  # Output directory

    chunksize = 50000
    # Process the variant data in chunks (50000 rows at a time)
    for df in pd.read_csv(variants + 'variant_effect_output_distance.txt', sep="\t", skiprows=4, chunksize=chunksize):
        # Extract relevant information from the 'INFO' column
        df2 = df.INFO.str.split(",", expand=True).iloc[:, 1:]
        df2 = df2.fillna(value=np.nan)
        df2 = df2.replace("", np.nan)
        
        # Convert the data in df2 to float (if possible)
        for i in range(1, len(df2.columns)):
            df2[i] = df2[i].astype(float)

        # Calculate mean, max, and min distance and add as new columns in the DataFrame
        df['mean_distance_variant_transcript'] = df2.mean(axis=1, skipna=True)
        df['max_distance_variant_transcript'] = df2.max(axis=1, skipna=True)
        df['min_distance_variant_transcript'] = df2.min(axis=1, skipna=True)

        # Drop 'ID' and 'INFO' columns and rename columns for clarity
        df = df.drop(["ID", "INFO"], axis=1)
        df.columns = ["chrom", "pos", "ref_allele", "alt_allele", "R", "driver_stat", "mean_distance_variant_transcript", "max_distance_variant_transcript", "min_distance_variant_transcript"]
        
        # Round numeric columns to two decimal places
        df = df.round(2)

        # Save the processed DataFrame to a TSV file
        file_path = outputDir + "vepDistance.bed"
        if os.path.exists(file_path):
            df.to_csv(file_path, header=None, index=None, sep="\t", mode='a')
        else:
            # If the file doesn't exist, create it with column headers
            df.to_csv(file_path, index=None, sep="\t")

