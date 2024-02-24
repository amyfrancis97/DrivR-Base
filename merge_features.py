import sys
import pandas as pd
if __name__ == "__main__":
    # Define file paths and output directory
    variant_file = sys.argv[1]  # Path to the variant file
    outputDir = sys.argv[2]  # Output directory
    variants = pd.read_csv(variant_file, sep = "\t", names=["chrom", "pos", "ref_allele", "alt_allele", "driver_stat"], dtype = {'chrom': str, 'pos': int, 'ref_allele': str, 'alt_allele': str, 'driver_stat': int}).drop_duplicates(keep = "first").reset_index(drop = True)
    variants = variants.dropna().reset_index(drop = True)
    file_list = [
        "10_1_kernel.txt", "10_2_kernel.txt", "10_3_kernel.txt", "10_4_kernel.txt", "10_5_kernel.txt",
        "10_6_kernel.txt", "10_7_kernel.txt", "10_8_kernel.txt", "10_9_kernel.txt", "2_1_kernel.txt",
        "4_1_kernel.txt", "4_2_kernel.txt", "4_3_kernel.txt", "6_1_kernel.txt", "6_2_kernel.txt",
        "6_3_kernel.txt", "6_4_kernel.txt", "6_5_kernel.txt", "8_1_kernel.txt", "8_2_kernel.txt",
        "8_3_kernel.txt", "8_4_kernel.txt", "8_5_kernel.txt", "8_6_kernel.txt", "8_7_kernel.txt",
        "GC.csv", "dnaShape.txt","dinucleotideProperties.txt", "AAproperties.txt", "AASubstMatrices.txt",
        "hg38.phastCons100way.bedGraph", "hg38.phastCons17way.bedGraph", "hg38.phastCons20way.bedGraph",
        "hg38.phastCons30way.bedGraph", "hg38.phastCons470way.bedGraph", "hg38.phastCons4way.bedGraph",
        "vepAA.bed", "vepAA_OHE.bed", "vepConsequences.bed", "hg38.phyloP100way.bedGraph", "hg38.phyloP17way.bedGraph", "hg38.phyloP20way.bedGraph",
        "hg38.phyloP30way.bedGraph", "hg38.phyloP470way.bedGraph", "hg38.phyloP4way.bedGraph",
        "hg38.k100.Bismap.MultiTrackMappability.bedGraph", "hg38.k100.Umap.MultiTrackMappability.bedGraph",
        "hg38.k24.Bismap.MultiTrackMappability.bedGraph", "hg38.k24.Umap.MultiTrackMappability.bedGraph",
        "hg38.k36.Bismap.MultiTrackMappability.bedGraph", "hg38.k36.Umap.MultiTrackMappability.bedGraph",
        "hg38.k50.Bismap.MultiTrackMappability.bedGraph", "hg38.k50.Umap.MultiTrackMappability.bedGraph",
    ]

    df = pd.DataFrame()
    # Import cosmic dataquit()set
    for file in file_list:
        if "way" in file or "Multi" in file: 
            dataset = pd.read_csv(outputDir + file, sep = "\t", header = None, names = ['chrom', 'pos', 'ref_allele', 'alt_allele', ''.join(file.split("/")[len(file.split("/"))-1].split(".")[0:2]) + 'score'], 
                                                                            dtype = {'chrom': str, 'pos': int, 'ref_allele': str, 'alt_allele': str}).drop_duplicates(keep = "first").reset_index(drop = True)
        else:
            dataset = pd.read_csv(outputDir + file, sep = "\t", dtype = {'chrom': str, 'pos': int, 'ref_allele': str, 'alt_allele': str}).drop_duplicates(keep = "first").reset_index(drop = True)
        if file == file_list[0]:
            df = variants.merge(dataset, how = "outer", on = ["chrom", "pos", "ref_allele", "alt_allele"])
        else: 
            df = df.merge(dataset, how = "outer", on = ["chrom", "pos", "ref_allele", "alt_allele"])

    df.to_csv(outputDir + "all_features.bed", sep = "\t", index= None)

