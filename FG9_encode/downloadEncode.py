import requests
import pandas as pd
import os
import re
from urllib import request
import gzip
import shutil
import sys
import urllib.request
import numpy as np


feature = sys.argv[1]
dir = sys.argv[2]

# Set the working directory
os.chdir(dir)

# Define the API URL and create a session object
apiurl = "https://www.encodeproject.org/"
session = requests.Session()

def query_api(path, query):
    """Query the API and retrieve JSON response
    
    Parameters:
        path (str): Path for API endpoint
        query (str): Query parameters
    
    Returns:
        headers: HTTP headers from API
        result: JSON response
    """
    res = session.get(f"{apiurl}{path}?{query}")
    headers = res.headers
    result = res.json()
    return headers, result

# Define the query for retrieving feature files
query="type=File&assay_title={}&status=released&output_category=annotation&file_format=bigBed&file_format_type=narrowPeak&assembly=GRCh38&limit=all&format=json"
# Query the API for the feature group
headers, result = query_api("search/", query.format(feature))

# Convert JSON response to DataFrame
data = pd.DataFrame.from_dict(result['@graph'])

testdf = pd.DataFrame()

try:
    # Extract necessary columns from the DataFrame
    testdf = data[["href", "accession", "target", "biosample_ontology", "output_type"]]
    # Extract the key from each dictionary and put it into a new column
    testdf["target"]= testdf['target'].apply(lambda x: x['label'])
    testdf["biosample_ontology"]= testdf['biosample_ontology'].apply(lambda x: x['term_name'])
except:
    # Extract necessary columns from the DataFrame
    testdf = data[["href", "accession", "biosample_ontology", "output_type"]]
    # Clean column values using regex patterns
    testdf["biosample_ontology"]= testdf['biosample_ontology'].apply(lambda x: x['term_name'])
# Add the 'feature' column to identify the feature group
testdf["feature"] = feature
testdf["output_type"] = testdf["output_type"].str.replace(" ", "_")
testdf["biosample_ontology"] = testdf["biosample_ontology"].str.replace(" ", "_")

if "peaks" in testdf["output_type"].unique().tolist():
    testdf = testdf[testdf["output_type"] == "peaks"].reset_index(drop = True)
elif "replicated_peaks" in testdf["output_type"].unique().tolist():
    testdf = testdf[(testdf["output_type"] == "replicated_peaks") | (testdf["output_type"] == 
"pseudoreplicated_peaks")].reset_index(drop = True)
testdf.to_csv(f"{dir}/{feature}_fileInfo.txt", sep = "\t", index = None)

def download_file(url, dest_path):
    with requests.get(url, stream=True) as response:
        response.raise_for_status()
        with open(dest_path, 'wb') as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)

def process_row(row):
    file_type = testdf.loc[row, "output_type"]
    file = testdf[testdf["output_type"] == file_type].reset_index(drop=True)
    accession = file.loc[row, "accession"]
    file_url = f"https://www.encodeproject.org/files/{accession}/@@download/{accession}.bigBed"
    dest_path = f"{dir}/{accession}.{feature}.bigBed"
    download_file(file_url, dest_path)

# Assuming 'testdf', 'dir', and 'feature' are defined
for i in range(0, len(testdf)):
    process_row(i)

