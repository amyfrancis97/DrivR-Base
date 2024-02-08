#%%
import pyBigWig
import pandas as pd
import sys

if __name__ == "__main__":
    variantDir = sys.argv[1]
    variantFileName = sys.argv[2]
    output_dir = sys.argv[3]

    # Read in variant file
    variants = pd.read_csv(f'{variantDir}{variantFileName}', sep = "\t", header = None, names = ["chrom", "start", "end", "ref_allele", "alt_allele"])

    # Conservation files
    files = [
        "phyloP4way", "phyloP7way", "phyloP17way", "phyloP20way", "phyloP30way",
        "phyloP100way", "phyloP470way", "phastCons4way", "phastCons7way", "phastCons17way",
        "phastCons20way", "phastCons30way", "phastCons100way", "phastCons470way",
        "k24.Bismap.MultiTrackMappability", "k36.Umap.MultiTrackMappability",
        "k36.Bismap.MultiTrackMappability", "k24.Umap.MultiTrackMappability",
        "k50.Bismap.MultiTrackMappability", "k50.Umap.MultiTrackMappability",
        "k100.Bismap.MultiTrackMappability", "k100.Umap.MultiTrackMappability"
    ]

    for file in files:
        try:
            if "way" in file:
                # Path to BigWig file
                bw_path = f'https://hgdownload.soe.ucsc.edu/goldenPath/hg38/{file}/hg38.{file}.bw'
            else:
                bw_path = f'http://hgdownload.soe.ucsc.edu/gbdb/hg38/hoffmanMappability/{file}.bw'
            # Open the BigWig file
            bw = pyBigWig.open(bw_path)

            # Initialise an empty list to store query results
            results = []

            # Loop through the DataFrame rows
            for index, row in variants.iterrows():
                # Query the BigWig file for each position
                value = bw.values(row['chrom'], row['start'], row['end'])[0] # Assuming we want the first value in the returned list
                results.append((row['chrom'], row['start'], row['end'], value))

            # Process the results 
            variants[file] = [result[3] for result in results]
            variants = variants.drop("start", axis = 1)

            # Save to CSV
            variants.to_csv(f'{output_dir}hg38{file}.bedGraph', header = None, sep = "\t", index = None)
            bw.close()
        except:
            print("cannot access file") # 470-way not available at the moment
#%%

