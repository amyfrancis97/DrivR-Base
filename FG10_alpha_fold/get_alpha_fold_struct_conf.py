import pandas as pd
import requests
import os
import sys
import numpy as np
import re

def getAlphaFoldScores(variantVEPresults, df4):
    # Replace the URL with the actual URL of the text file
    if df4["trembl"][variantVEPresults] is not None:
        url = "https://alphafold.ebi.ac.uk/files/AF-" + df4["trembl"][variantVEPresults] + "-F1-model_v4.cif"
        # Fetch the content of the text file
        response = requests.get(url)
        res = []
        atoms = []
        filtered_rows = []
        try:
            # Check if the request was successful (status code 200)
            if response.status_code == 200:
                # Read the content as text
                text_data = response.text
                # Split the text into lines
                lines = text_data.splitlines()

                # Iterate through each line and print lines starting with "ATO"
                all_lines = []
                for line in lines:

                    # Concatenate the words with a single tab between them
                    if line.startswith("A ") and "?" in line:
                        output_line = re.sub(r'\s+', ' ', line)
                        table_data = output_line.split(' ')
                        df_res = pd.DataFrame(table_data).transpose()
                        all_lines.append(df_res)

                        
                res = pd.concat(all_lines).reset_index(drop=True)
                
                target_value = df4["protein_position"][variantVEPresults]

                if "-" in target_value and "?" not in target_value:
                    target_value = int(target_value.split("-")[0])
                elif "-" not in target_value and "?" not in target_value:
                    target_value = int(target_value)
                else:
                    target_value = np.nan

                # Convert column 2 to numeric values for comparison
                res[2] = pd.to_numeric(res[2])

                # Filter the rows based on the condition
                filtered_rows = res[(res[2] <= target_value) & (target_value <= res[2].shift(-1))]

            if len(res) != 0:
                res = pd.concat([pd.DataFrame(df4.iloc[variantVEPresults, :7]).transpose().reset_index(drop=True), filtered_rows.reset_index(drop = True)], axis = 1)
                return res
        except:
            x="y"

if __name__ == "__main__":
    variantDir = sys.argv[1]
    variants = variantDir + sys.argv[2]

    results = []
    chunksize = 10
    for chunk in  pd.read_csv(variants + "_variant_effect_output_all.txt", sep = "\t", header = None, low_memory=False, chunksize=chunksize):
        df2 = chunk[7].str.split("ENST", expand = True)[1].str.split("|", expand = True)

        # Extract protein ID's and protein position from VEP results
        uniparc = df2[19].str.split(".", expand = True)[0]
        uniprot = df2[20].str.split(".", expand = True)[0]
        trembl = df2[18].str.split(".", expand = True)[0]
        swissprot = df2[17].str.split(".", expand = True)[0]
        proteinPosition = df2[8]
        gene = chunk[7].str.split("ENST", expand = True)[0].str.split("|", expand = True)[3]

        # Create a new dataframe with these values
        df3 = pd.concat([chunk.iloc[:, :7], gene, uniprot, uniparc, trembl, swissprot, proteinPosition], axis =1)
        df3 = df3.drop(2, axis = 1)
        df3.columns = ["chrom", "pos", "ref_allele", "alt_allele", "R", "driver_stat", "gene", "uniprot", "uniparc", "trembl", "swissprot", "protein_position"]

        # only retreive info for those with protein position
        df4 = df3[(df3["protein_position"] != "") & (df3["trembl"] != "") & (df3["trembl"] != np.nan) & (df3["protein_position"] != np.nan)].reset_index(drop = True)
        res2 = [getAlphaFoldScores(i, df4) for i in range(0, len(df4))]

        res3 = pd.DataFrame()

        if len(res2) != 0:
            res3 = pd.concat(res2)
            res3 = res3.drop([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16], axis = 1)
            struct_conf_list = ["_struct_conf.conf_type_id", "_struct_conf.id"]
            res3.columns = res3.columns.tolist()[:6] + struct_conf_list
            print("res3:", res3)
            results.append(res3)

    print("results:", results)
    results2 = pd.concat(results)

    # One-hot-encoding of structural conformation results
    results_encoded = pd.get_dummies(results2, columns=['_struct_conf.conf_type_id', '_struct_conf.id'])
    file_path = variantDir + "alpha_fold_pbd_struct_conf.txt"
    results_encoded.to_csv(file_path, mode= "w", index=False, sep = "\t")  
