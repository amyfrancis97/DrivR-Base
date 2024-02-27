# Install Packages
import pandas as pd
import sys

# Read in file and re-write to fix any formatting issues
input_file = sys.argv[1]
output_file = sys.argv[2]
df = pd.read_csv(input_file, sep = "\t", header = None)
df.to_csv(output_file, sep = "\t", header = None, index=None)
