import pandas as pd
import sys

feature = sys.argv[1]
dir = sys.argv[2]

# read in the annotation file
df_anno = pd.read_csv(f"{dir}/{feature}_fileInfo.txt", sep = "\t")

# read in the peak file
df = pd.read_csv(f"{dir}/{feature}.bed", sep = "\t", names = ["chrom", "start", "end", "name", "score", "strand", 
"signalValue", "pValue", "qValue", "peak", "accession"])

# merge peaks wit annotation
df = df.merge(df_anno, on = "accession")

# write file
df.to_csv(f"{dir}/{feature}_feature+anno.txt", sep = "\t", index = None)
