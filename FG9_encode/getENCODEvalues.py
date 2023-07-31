import pandas as pd
import numpy as np
import sys
import os 

# function for TF data, eclip, histone, 
def getTFdf(row, df, df_unique):
    
    # fill in the chromosomes, start, end, and alleles for the positions
    chrom = df_unique.loc[row, 0]
    start = df_unique.loc[row, 1]
    end = df_unique.loc[row, 2]
    ref_allele = df_unique.loc[row, 3]
    alt_allele = df_unique.loc[row, 4]
    R = df_unique.loc[row, 5]
    driver_stat = df_unique.loc[row, 6]

    # define the dataframe with chromosomal positions and all possible targets
    data = pd.DataFrame(data = {"chrom":[chrom],"start":[start], "end":[end], "ref_allele":[ref_allele], "alt_allele":[alt_allele], "R":[R], "driver_stat":[driver_stat]})
    nested_list = [[s + "_" + i for i in df[9].unique().tolist()] for s in df[8].unique().tolist()]
    flat_list = [item for sublist in nested_list for item in sublist]
    data = data.reindex(columns = data.columns.tolist() + flat_list)
    
    # for each unique target for the variant, pull out the value
    mask = (df[0] == chrom) & (df[1] == start) & (df[2] == end) & (df[3] == ref_allele) & (df[4] == alt_allele)
    testing = df.loc[mask].reset_index(drop=True)

    def getTargetValue(tf, testing):
        if tf in testing[8].tolist():
            mask = (testing[8] == tf)
            testing = testing.loc[mask].reset_index(drop=True)
            if len(testing) == 1: # if there is a matching target with one peak value fill in the value
                data[tf + "_" + testing.loc[0, 9]] = round(testing.loc[0, 11], 2)
            elif len(testing) > 1: # if there are multiple peak values for a given position and target, take the mean
                for unique_peak in testing[9].unique():
                    mask = (testing[9] == unique_peak)
                    testing = testing.loc[mask].reset_index(drop=True)
                    data[tf + "_" + unique_peak] = round(testing[11].mean(), 2)
        else:
            "nothing"

    # carry out above function for each unique target value
    [getTargetValue(tf, testing) for tf in df[8].unique().tolist()]
    return data

# function for dnase/ gm-dnase seq
def getSeqdf(row, df, df_unique):
    
    # fill in the chromosomes, start, end, and alleles for the positions
    chrom = df_unique.loc[row, 0]
    start = df_unique.loc[row, 1]
    end = df_unique.loc[row, 2]
    ref_allele = df_unique.loc[row, 3]
    alt_allele = df_unique.loc[row, 4]
    R = df_unique.loc[row, 5]
    driver_stat = df_unique.loc[row, 6]

    # define the dataframe with chromosomal positions and all possible targets
    data = pd.DataFrame(data = {"chrom":[chrom],"start":[start], "end":[end], "ref_allele":[ref_allele], "alt_allele":[alt_allele], "R":[R], "driver_stat":[driver_stat]})
    
    # for each unique target for the variant, pull out the value
    mask = (df[0] == chrom) & (df[1] == start) & (df[2] == end) & (df[3] == ref_allele) & (df[4] == alt_allele)
    testing = df.loc[mask].reset_index(drop=True)

    def getPeakType(peaktype, testing):
        value_hotspots = np.nan
        value_peaks_lower = np.nan
        value_peaks_higher = np.nan
        if peaktype in testing[9].tolist():
            mask = (testing[9] == peaktype)
            testing = testing.loc[mask].reset_index(drop=True)
            if peaktype == "hotspots":
                value_hotspots = round(testing[11].mean(), 2)
            else:
                try:
                    value_peaks_lower = round(testing.loc[testing[11] < 10, 11].mean(), 2)
                except:
                    value_peaks_lower = np.nan
                try:
                    value_peaks_higher = round(testing.loc[testing[11] > 10, 11].mean(), 2)
                except:
                    value_peaks_higher = np.nan

        data["hotspots"] = value_hotspots
        data["lower_peaks"] = value_peaks_lower
        data["higher_peaks"] = value_peaks_higher
        return(value_hotspots, value_peaks_lower, value_peaks_higher)
    
    res= [getPeakType(peaktype, testing) for peaktype in df[9].unique().tolist()]
    return(data)

features = ["TF+ChIP-seq", "eCLIP", "Histone+ChIP-seq", "Mint-ChIP-seq", "ATAC-seq", "ChIA-PET", "GM+DNase-seq", "DNase-seq", "STARR-seq"]

if __name__ == "__main__":
    feature = sys.argv[1]
    outputDir = sys.argv[2]
    chunks = 500
    chunkList = []
    for chunk in pd.read_csv(outputDir + feature + "_intersects.bed", sep = "\t", header = None, chunksize=chunks):
        df = chunk.reset_index(drop=True)
        df_unique = df.iloc[:, 0:7].drop_duplicates().reset_index()
        if feature == "TF+ChIP-seq" or feature == "eCLIP" or feature == "Histone+ChIP-seq" or feature == "Mint-ChIP-seq" or feature == "ATAC-seq" or feature == "ChIA-PET":
            tests = pd.concat([getTFdf(row, df, df_unique) for row in range(0, len(df_unique))]).reset_index(drop = True)
        elif feature == "GM+DNase-seq" or feature == "DNase-seq" or feature == "STARR-seq":
            tests = pd.concat([getSeqdf(row, df, df_unique) for row in range(0, len(df_unique))]).reset_index(drop = True)
        tests = tests.drop("end", axis =1)
        tests = tests.rename(columns = {"start": "pos"})
        file_path = outputDir + feature + ".txt"
        chunkList.append(tests)
        if os.path.exists(file_path):
            tests.to_csv(file_path, header = None, index = None, sep = "\t", mode = 'a')
        else:
            tests.to_csv(file_path, index = None, sep = "\t")
