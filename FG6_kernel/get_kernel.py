from Bio import SeqIO
import os
import pandas as pd
from strkernel.mismatch_kernel import MismatchKernel
from strkernel.mismatch_kernel import preprocess
from Bio import SeqIO
from Bio.Seq import Seq
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_curve, auc, precision_recall_curve, average_precision_score
from sklearn.metrics import classification_report # classfication summary
import matplotlib.pyplot as plt
import numpy as np
from numpy import random
import sys
from itertools import islice
import glob
import multiprocessing
from config import *
from functools import reduce

def process_kmer(windowSize, kmerSize):
    # kmer of window size 5 and kmer size 3
    # get sequences given a set of variants and specified sequence lengths
    variantsSequences = getSequences(variants, windowSize, kmerSize)
    spectrumFeatureList = [getSpectrumFeatures(list(variantsSequences.loc[i, :])[0], list(variantsSequences.loc[i, :])[1], kmerSize) for i in range(0, len(variantsSequences))]
    spectrumList = [list(spectrumFeatureList[x].loc[0, :]) + list(spectrumFeatureList[x].loc[1, :]) for x in range(0, len(spectrumFeatureList))]
    spectrumdf = pd.DataFrame(spectrumList)
    spectrumdf = pd.concat([variants, spectrumdf], axis=1)
    spectrumdf["chrom"] = spectrumdf["chrom"]
    spectrumdf["pos"] = spectrumdf["pos"].astype(int)
    spectrumdf = spectrumdf.rename(columns={0: str(windowSize*2) + "_" + str(kmerSize) + "_w", 1: str(windowSize*2) + "_" + str(kmerSize) + "_x", 2: str(windowSize*2) + "_" + str(kmerSize) + "_y", 3: str(windowSize*2) + "_" + str(kmerSize) + "_z"})
    spectrumdf = spectrumdf.drop("pos2", axis = 1)

    # save each result to CSV file
    spectrumdf.to_csv(outputDir  + str(windowSize*2) + "_" + str(kmerSize) + "_kernel.txt", sep="\t", index = False)

# unput is the variant dataset and window size either side of the variants (e.g. w of 100 = 200 bp in total)
def getSequences(dataset, window_size, k):
    kmerDf = pd.DataFrame()
    similarityArray = []

    def getSeqFun(i):

        # generates wild type sequence
        # by refering to the reference sequence, it gets the sequences flanking 100bp either side of the variant position
        wildType = str(record_dict[dataset.loc[i, "chrom"]].seq[int(dataset.loc[i, "pos"]-1-window_size):int(dataset.loc[i, "pos"]-1+window_size)]).upper()

        # mutant sequence
        # repeats the same as above but replaces WT variant with the mutant variant
        mutant = str(record_dict[dataset.loc[i, "chrom"]].seq[int(dataset.loc[i, "pos"]-1-window_size):int(dataset.loc[i, "pos"]-1)]) + dataset.loc[i, "alt_allele"] + str(record_dict[dataset.loc[i, "chrom"]].seq[int(dataset.loc[i, "pos"]):int(dataset.loc[i, "pos"]-1+window_size)]).upper()

        kmerDf.loc[i, "wildType"] = wildType.upper()
        kmerDf.loc[i, "mutant"] = mutant.upper()

    # Carries out function for each variant in the dataset
    [getSeqFun(i) for i in range(0, len(variants))]
    return kmerDf


# generator function
# generates all combinations of k-mers for the sequences
def over_slice(test_str, K):
    itr = iter(test_str)
    res = tuple(islice(itr, K))
    if len(res) == K:
        yield res   
    for ele in itr:
        res = res[1:] + (ele,)
        yield res

def getSpectrumFeatures(seq1, seq2, k): 
    # initializing string
    test_str = seq1 + seq2

    # initializing K
    K = k
    
    # calling generator function
    res = ["".join(ele) for ele in over_slice(test_str, K)]
    dfMappingFunction = pd.DataFrame(columns = ["seq"] + res)
    dfMappingFunction.loc[0, "seq"] = seq1
    dfMappingFunction.loc[1, "seq"] = seq2

    # generate mapping function
    def getMappingFunction(res, seq):
        if res in seq: # if the k-mer is present in the sequence, count the number of occurences in the sequence
            dfMappingFunction.loc[dfMappingFunction["seq"] == seq, res] = dfMappingFunction.loc[dfMappingFunction["seq"] == seq, "seq"].reset_index(drop=True)[0].count(res) 
        else: # if its not in the sequence, fill with a 0
            dfMappingFunction.loc[dfMappingFunction["seq"] == seq, res] = 0

    for seq in [seq1, seq2]:
        [getMappingFunction(x, seq) for x in res]

    # generate p-spectra
    pSpectrumKernel = pd.DataFrame(columns=[seq1, seq2])
    pSpectrumKernel.insert(0, "seq", [seq1, seq2])

    # to derive p-spectra, take product of each column and sum together
    products_WT_mut = [np.prod(dfMappingFunction.iloc[:, i]) for i in range(1, len(dfMappingFunction.columns))]
    sum_WT_mut  = np.sum(products_WT_mut)
    pSpectrumKernel.iloc[0, 2] = sum_WT_mut
    pSpectrumKernel.iloc[1, 1] = sum_WT_mut
    # to derive the diagonal of the kernel matrix, we take the sum of the squares for the corresponding row
    squares_WT = [np.square(dfMappingFunction.iloc[0, i]) for i in range(1, len(dfMappingFunction.columns))]
    squares_mutant = [np.square(dfMappingFunction.iloc[1, i]) for i in range(1, len(dfMappingFunction.columns))]
    pSpectrumKernel.iloc[0, 1] = np.sum(squares_WT)
    pSpectrumKernel.iloc[1, 2] = np.sum(squares_mutant)
    return pSpectrumKernel.drop("seq", axis = 1)
    
def getFinalSpectrumDf(windowSize, kmerSize):
    # kmer of window size 5 and kmer size 3
    # get sequences given a set of variants and specified sequence lengths
    variantsSequences = getSequences(variants, windowSize, kmerSize)
    spectrumFeatureList = [getSpectrumFeatures(list(variantsSequences.loc[i, :])[0], list(variantsSequences.loc[i, :])[1], kmerSize) for i in range(0, len(variantsSequences))]
    spectrumList = [list(spectrumFeatureList[x].loc[0, :]) + list(spectrumFeatureList[x].loc[1, :]) for x in range(0, len(spectrumFeatureList))]
    spectrumdf = pd.DataFrame(spectrumList)
    spectrumdf = pd.concat([variants, spectrumdf], axis = 1)
    spectrumdf["chrom"] = spectrumdf["chrom"].str.replace("chr", "").astype(str)
    spectrumdf["pos"] = spectrumdf["pos"].astype(int)
    spectrumdf = spectrumdf.rename(columns = {0: str(windowSize*2) + "_" + str(kmerSize) + "_w", 1: str(windowSize*2) + "_" + str(kmerSize) + "_x", 2: str(windowSize*2) + "_" + str(kmerSize) + "_y", 3: str(windowSize*2) + "_" + str(kmerSize) + "_z"})
    spectrumdf = spectrumdf.drop("pos2", axis = 1)    


if __name__ == "__main__":
    variantDir = sys.argv[1]
    variants = variantDir + sys.argv[2]
    outputDir = sys.argv[3]

    # Reads in the human GRCh38 genome in fasta format
    record_dict = SeqIO.to_dict(SeqIO.parse(hg38_seq, "fasta"))

    chunk_size = 1000
    for chunk in pd.read_csv(variants, sep = "\t", names = ['chrom', 'pos', 'pos2', 'ref_allele', 'alt_allele'], chunksize = chunk_size):
        # Reading in the variant file
        variants = chunk
        # Removes sex chromosomes
        variants = variants[(variants['chrom'] != "chrX") & (variants['chrom'] != "chrY")]
        variants = variants.reset_index(drop = True)

        # List of window sizes and kmer sizes for which you want to compute the kernels
        window_sizes = [1, 2, 3, 4, 5]
        kmer_sizes_list = [
            list(range(1, 2)),
            list(range(1, 4, 1)),
            list(range(1, 6, 1)),
            list(range(1, 8, 1)),
            list(range(1, 10, 1))
        ]

        # Create a pool of worker processes with the number of cores you want to use
        num_cores = multiprocessing.cpu_count()  # Use all available cores
        pool = multiprocessing.Pool(processes=num_cores)

        # Use the pool of processes to parallelize the computation
        for window_size, kmer_sizes in zip(window_sizes, kmer_sizes_list):
            pool.starmap(process_kmer, [(window_size, kmer_size) for kmer_size in kmer_sizes])

        # Close the pool of processes
        pool.close()
        pool.join()
    
    os.chdir(outputDir)
    dfs = []
    for file in glob.glob("*kernel.txt"):
        dfs.append(pd.read_csv(file, sep = "\t"))
        os.remove(file)

    merged_df = dfs[0]
    for df in dfs[1:]:
        merged_df = pd.merge(merged_df, df, on=["chrom", "pos", "ref_allele", "alt_allele"], how='outer')
    merged_df.to_csv(outputDir  + "spectrum_kernels.txt", sep="\t", index = False)

