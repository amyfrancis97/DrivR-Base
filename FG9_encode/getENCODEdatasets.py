import requests
import pandas as pd
import os
import re
from urllib import request
import gzip
import shutil
from multiprocessing.pool import ThreadPool
import sys

feature = sys.argv[1]
dir = sys.argv[2]

print(feature)
print(dir)

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
query = "type=File&assay_title={}&status=released&output_category=annotation&file_format=bigBed&file_format=bed&assembly=GRCh38&limit=all&format=json"

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

def download_url(url):
    """Download the file from the given URL
    
    Parameters:
        url (str): URL of the file to be downloaded
    """
    print("downloading: ", url)
    
    # Extract the file title from the URL
    file_title = re.split(pattern='/', string=url)[-1]
    
    # Send a GET request to download the file
    r = session.get(url, stream=True)
    r.raise_for_status()
    
    # Save the downloaded file
    with open(file_title, 'wb') as f_out:
        for chunk in r.iter_content(chunk_size=8192):
            if chunk:
                f_out.write(chunk)

    title = ""    
    if ".bed." in file_title:
        # Create the title for the unzipped file
        title = re.split(pattern=r'\.bed', string=file_title)[0] + ".csv"
    elif ".bigBed." in file_title:
        title = re.split(pattern=r'\.bigBed', string=file_title)[0] + ".csv"
    
    if ".gz" in file_title:
        # Unzip the downloaded file
        with gzip.open(file_title, 'rb') as f_in:
            with open(title, 'wb') as f_out:
                shutil.copyfileobj(f_in, f_out)
    else:
        os.rename(file_title, title)

def process_row(row, feature_files):
    """Process a single row of feature_files DataFrame
    
    Parameters:
        row (int): Row index
        feature_files (DataFrame): DataFrame containing feature file information
    
    Returns:
        df_filtered (DataFrame): Filtered DataFrame with processed data
    """
    df_filtered = pd.DataFrame()
    accession = feature_files.loc[row, "accession"]
    output_type = feature_files.loc[row, "output_type"]
    feature = feature_files.loc[row, "feature"]
    biosample_ontology = feature_files.loc[row, "biosample_ontology"]        
    try:
        # Try different URL variations one by one
        download_url("https://www.encodeproject.org/files/" + accession + "/@@download/" + accession + ".bed.gz")
        df = pd.read_csv(accession + ".csv", sep="\t", engine="python", header=None)
        print(".bed.gz:")
        print(df.head())
        df_filtered = df[[0, 1, 2, 6]].rename(columns={0: "chrom", 1: "start", 2: "end", 6: "value"})
        df_filtered["start"] = df_filtered["start"].astype("int")
        df_filtered["end"] = df_filtered["end"].astype("int")
        df_filtered["accession"] = accession
        if "target" in feature_files.columns:
            target = feature_files.loc[row, "target"]
            df_filtered["target"] = target
        else:
            df_filtered["target"] = "n/a"
        df_filtered["output_type"] = output_type
        df_filtered["feature"] = feature
        df_filtered["biosample_ontology"] = biosample_ontology

        # Replace spaces with underscores in output_type column
        df_filtered.output_type = df_filtered.output_type.str.replace(' ', '_')

        os.remove(accession + ".csv")
        os.remove(accession + ".bed.gz")
        
    except requests.exceptions.HTTPError:
        try:
            download_url("https://www.encodeproject.org/files/" + accession + "/@@download/" + accession + ".bigBed.gz")
            df = pd.read_csv(accession + ".csv", sep="\t", engine="python", header=None)
            print(".bigBed.gz:")
            print(df.head())
            df_filtered = df[[0, 1, 2, 6]].rename(columns={0: "chrom", 1: "start", 2: "end", 6: "value"})
            df_filtered["start"] = df_filtered["start"].astype("int")
            df_filtered["end"] = df_filtered["end"].astype("int")
            df_filtered["accession"] = accession
            if "target" in feature_files.columns:
                target = feature_files.loc[row, "target"]
                df_filtered["target"] = target
            else:
                df_filtered["target"] = "n/a"
            df_filtered["output_type"] = output_type
            df_filtered["feature"] = feature
            df_filtered["biosample_ontology"] = biosample_ontology

            # Replace spaces with underscores in output_type column
            df_filtered.output_type = df_filtered.output_type.str.replace(' ', '_')

            os.remove(accession + ".csv")
            os.remove(accession + ".bigBed.gz")


        except requests.exceptions.HTTPError:
            try:
                download_url("https://www.encodeproject.org/files/" + accession + "/@@download/" + accession + ".bigBed")
                df = pd.read_csv(accession + ".csv", sep="\t", engine="python", header=None)
                print(".bigBed:")
                print(df.head())
                df_filtered = df[[0, 1, 2, 6]].rename(columns={0: "chrom", 1: "start", 2: "end", 6: "value"})
                df_filtered["start"] = df_filtered["start"].astype("int")
                df_filtered["end"] = df_filtered["end"].astype("int")
                df_filtered["accession"] = accession
                if "target" in feature_files.columns:
                    target = feature_files.loc[row, "target"]
                    df_filtered["target"] = target
                else:
                    df_filtered["target"] = "n/a"
                df_filtered["output_type"] = output_type
                df_filtered["feature"] = feature
                df_filtered["biosample_ontology"] = biosample_ontology

                # Replace spaces with underscores in output_type column
                df_filtered.output_type = df_filtered.output_type.str.replace(' ', '_')

                os.remove(accession + ".csv")
                os.remove(accession + ".bigBed")

            except requests.exceptions.HTTPError:
                try:
                    download_url("https://www.encodeproject.org/files/" + accession + "/@@download/" + accession + ".bed")
                    df = pd.read_csv(accession + ".csv", sep="\t", engine="python", header=None)
                    print(".bed:")
                    print(df.head())
                    df_filtered = df[[0, 1, 2, 6]].rename(columns={0: "chrom", 1: "start", 2: "end", 6: "value"})
                    df_filtered["start"] = df_filtered["start"].astype("int")
                    df_filtered["end"] = df_filtered["end"].astype("int")
                    df_filtered["accession"] = accession
                    if "target" in feature_files.columns:
                        target = feature_files.loc[row, "target"]
                        df_filtered["target"] = target
                    else:
                        df_filtered["target"] = "n/a"
                    df_filtered["output_type"] = output_type
                    df_filtered["feature"] = feature
                    df_filtered["biosample_ontology"] = biosample_ontology

                    # Replace spaces with underscores in output_type column
                    df_filtered.output_type = df_filtered.output_type.str.replace(' ', '_')

                    os.remove(accession + ".csv")
                    os.remove(accession + ".bed")
    

                except requests.exceptions.HTTPError:
                    print("Error: File not found for accession", accession)
                    # Handle the case where none of the URLs work

    df_filtered["start"] = df_filtered["start"].astype("int")
    df_filtered["end"] = df_filtered["end"].astype("int")
    if os.path.exists(feature + "_results_encode_appended.txt"):
        df_filtered.to_csv(feature + "_results_encode_appended.txt", mode='a', header=False, index=None, sep="\t")
    else:
        df_filtered.to_csv(feature + "_results_encode_appended.txt", index=None, sep="\t")
    return df_filtered
    
    # Save vepData dataframe to CSV



# Use ThreadPool for parallel execution
pool = ThreadPool(processes=8)  # Adjust the number of processes as per your system's capacity

# Map the process_row function to each row in feature_files DataFrame
results = pool.starmap(process_row, [(row, testdf) for row in range(len(testdf))])

pool.close()
pool.join()

