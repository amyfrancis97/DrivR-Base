from packages_dependencies import *
from config import *

if __name__ == "__main__":
    variantType = sys.argv[1]
    print(variantType)
    variants = sys.argv[1] + sys.argv[2]
    outputDir = sys.argv[3]

    # reads in the human GRCh38 genome in fasta format
    record_dict = SeqIO.to_dict(SeqIO.parse(hg38_seq, "fasta"))

    # reading in the variant file
    variants = pd.read_csv(variants, sep="\t", names=['chrom', 'pos', 'pos2', 'ref_allele', 'alt_allele', 'R', 'driver_stat'])

    # Drops variants on the sex chromosomes
    variants = variants[(variants['chrom'] != "chrX") & (variants['chrom'] != "chrY")]
    variants = variants.reset_index(drop=True)

    # For a given variant and window size, this function queries the HG38 genome
    # Extracts the wild type sequence
    # Calculates the GC content and CpG Count
    def getGCContent(variantIndex, windowSize):
        wildType = str(record_dict[variants.loc[variantIndex, "chrom"]].seq[
                       int(variants.loc[variantIndex, "pos"] - 1 - windowSize):int(
                           variants.loc[variantIndex, "pos"] - 1 + windowSize)]).upper()
        GCContent = round((wildType.count("G") + wildType.count("C")) / len(wildType) * 100, 2)
        CpGCount = wildType.count("CG")
        if wildType.count("G") != 0 and wildType.count("C") != 0:
            CpG_obs_exp = round((CpGCount * len(wildType)) / (wildType.count("G") * wildType.count("C")), 2)
        else:
            CpG_obs_exp = 0
        return GCContent, CpGCount, CpG_obs_exp

    # Carries out above function and appends into a dataframe
    def getGC(windowSize):
        # Use multiprocessing.Pool for parallel processing
        pool = Pool()
        GCDf = pool.starmap(getGCContent, [(x, windowSize) for x in range(0, len(variants))])
        pool.close()
        pool.join()

        GCdataframe = pd.concat([variants, pd.DataFrame(GCDf)], axis=1)
        GCdataframe["chrom"] = GCdataframe["chrom"].str.replace("chr", "").astype(str)
        GCdataframe["pos"] = GCdataframe["pos"].astype(int)
        GCdataframe = GCdataframe.rename(
            columns={0: str(windowSize * 2) + "GCContent", 1: str(windowSize * 2) + "CpGCount",
                     2: str(windowSize * 2) + "CpG_obs_exp"})
        GCdataframe = GCdataframe.drop("pos2", axis=1)
        GCdataframe['chrom'] = 'chr' + GCdataframe['chrom'].astype(str)
        return(GCdataframe)

    # Applies above function to different window sizes
    dataframeList=[]
    for i in [10, 20, 30, 40, 50, 100, 250, 500, 1000]:
        dataframeList.append(getGC(i))
    from functools import reduce
    data_merge = reduce(lambda left, right:     # Merge DataFrames in list
                     pd.merge(left , right,
                              on = ["chrom", "pos", "ref_allele", "alt_allele", "R", "driver_stat"],
                              how = "outer"),
                     dataframeList)
    # Write the merged dataframe to a CSV file
    output_file = os.path.join(outputDir, "GC.csv")
    data_merge.to_csv(output_file, index=None, sep="\t")
    print(data_merge)

