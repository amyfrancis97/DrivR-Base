import pandas as pd
import requests
import os
import sys
import numpy as np
from unipressed import IdMappingClient
import time
import re

def getAlphaFoldAtom(variantVEPresults, df4):
    # Replace the URL with the actual URL of the text file
    if df4["uniprot_conversion"][variantVEPresults] is not None and df4["protein_position"][variantVEPresults] is not None:
        url = "https://alphafold.ebi.ac.uk/files/AF-" + df4["uniprot_conversion"][variantVEPresults] + "-F1-model_v4.cif"
        # Fetch the content of the text file
        response = requests.get(url)
        res = []
        atoms = []
        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # Read the content as text
            text_data = response.text
            # Split the text into lines
            lines = text_data.splitlines()

            # Iterate through each line and print lines starting with "ATO"
            for line in lines:

                # Concatenate the words with a single tab between them
                result_string = ' '.join(["ATOM", df4["protein_position"][variantVEPresults]])
                if line.startswith(result_string):

                    table_data = line.split('\t')
                    atoms.append(line)

        try:
            # Split the string by white spaces and remove any empty strings resulting from consecutive white spaces
            result_list = [field.strip() for field in atoms[0].split() if field.strip()]
            res = pd.DataFrame(result_list).transpose()
        except:
            res = []
        
        if len(res) != 0:
            res = pd.concat([pd.DataFrame(df4.iloc[variantVEPresults, :7]).transpose().reset_index(drop=True), res],axis = 1)
            return res

def getAlphaFoldStructConf(variantVEPresults, df4):
    # Replace the URL with the actual URL of the text file
    if df4["uniprot_conversion"][variantVEPresults] is not None and df4["protein_position"][variantVEPresults] is not None:
        url = "https://alphafold.ebi.ac.uk/files/AF-" + df4["uniprot_conversion"][variantVEPresults] + "-F1-model_v4.cif"
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
                res = pd.concat([pd.DataFrame(df4.iloc[variantVEPresults, :7]).transpose().reset_index(drop=True), filtered_rows.reset_index(drop=True)], axis=1)
                return res
            else:
                return None  # Return None when there is no valid result
        except:
            return None  # Return None if an exception occurs

if __name__ == "__main__":
    variantDir = sys.argv[1]
    variants = variantDir + sys.argv[2]

    with open(variants + "_variant_effect_output_all.txt", 'r') as fin:
        data = fin.read().splitlines(True)
    with open(variants + "_variant_effect_output_all.head.rem.txt", 'w') as fout:
        fout.writelines(data[5:])

    results = []
    chunksize = 1000
    for chunk in pd.read_csv(variants + "_variant_effect_output_all.head.rem.txt", sep="\t", header=None, low_memory=False, chunksize=chunksize):

        # REMOVE BELOW SECTION IF YOU HAVE ALTERNATIVE INPUT FILE
        ##################################################################
        df2 = chunk[7].str.split("ENST", expand=True)[1].str.split("|", expand=True)
        proteinPosition = df2[8]
        gene = chunk[7].str.split("ENST", expand=True)[0].str.split("|", expand=True)[3]

        # Create a new dataframe with these values
        df3 = pd.concat([chunk.iloc[:, :7], gene, proteinPosition], axis=1)
        df3 = df3.drop(2, axis=1)
        df3.columns = ["chrom", "pos", "ref_allele", "alt_allele", "R", "driver_stat", "gene", "protein_position"]
        #####################################################################

        # If you are reading in the alternative file, rather than that generated from VEP, then use the code below
        # df3 = chunk

        df3["uniprot_conversion"] = np.nan

        lst = []
        for i in list(df3["gene"].unique()):

            request = IdMappingClient.submit(
                source="GeneCards", dest="UniProtKB", ids={i}
            )
            time.sleep(15)
            # Continuously check for the completion of the results
            while True:
                try:
                    ans = list(request.each_result())[0]
                    uniprot_conv = [x for x in ans.values()][1]
                    lst.append([i, uniprot_conv])
                    break  # Break the loop if successful
                except Exception as e:
                    print("Waiting for results:", e)
                    time.sleep(20)  # Adjust the sleep time based on your experience

            ans = list(request.each_result())[0]
            uniprot_conv = [x for x in ans.values()][1]
            lst.append([i, uniprot_conv])
        

        # Find rows where the condition is met
        condition = df3["gene"] == lst[0][0]
        # Update the specified column for the matching rows using .loc[]
        df3.loc[condition, "uniprot_conversion"] = lst[0][1]
        # only retrieve info for those with protein position
        df4 = df3[(df3["protein_position"] != "") & (df3["uniprot_conversion"] != "") & (df3["uniprot_conversion"] != np.nan) & (df3["protein_position"] != np.nan)].reset_index(drop=True)
        
        # Get the atom information
        res2 = [getAlphaFoldAtom(i, df4) for i in range(0, len(df4))]
        if len(res2) != 0:
            res3 = pd.concat(res2)

            atom_site_list = [
                "_atom_site.group_PDB",
                "_atom_site.id",
                "_atom_site.type_symbol",
                "_atom_site.label_atom_id",
                "_atom_site.label_alt_id",
                "_atom_site.label_comp_id",
                "_atom_site.label_asym_id",
                "_atom_site.label_entity_id",
                "_atom_site.label_seq_id",
                "_atom_site.pdbx_PDB_ins_code",
                "_atom_site.Cartn_x",
                "_atom_site.Cartn_y",
                "_atom_site.Cartn_z",
                "_atom_site.occupancy",
                "_atom_site.B_iso_or_equiv",
                "_atom_site.pdbx_formal_charge",
                "_atom_site.auth_seq_id",
                "_atom_site.auth_comp_id",
                "_atom_site.auth_asym_id",
                "_atom_site.auth_atom_id",
                "_atom_site.pdbx_PDB_model_num",
                "_atom_site.pdbx_sifts_xref_db_acc",
                "_atom_site.pdbx_sifts_xref_db_name",
                "_atom_site.pdbx_sifts_xref_db_num",
                "_atom_site.pdbx_sifts_xref_db_res",
            ]
            res3.columns = res3.columns.tolist()[:7] + atom_site_list
            res4 = pd.concat([res3.iloc[:,:6], res3.iloc[:,17:22]], axis = 1)
            res4 = res4[res4["chrom"].notna()]
            file_path = variantDir + "alpha_fold_pbd_atom_site.txt"
            if os.path.exists(file_path):
                res4.to_csv(file_path, mode= "a", index=False, sep = "\t", header = None)
            else:
                res4.to_csv(file_path, mode= "w", index=False, sep = "\t")

        # Get the structural conformation information
        res2 = [getAlphaFoldStructConf(i, df4) for i in range(0, len(df4))]

        res3 = pd.DataFrame()

        # Filter out None values from res2
        valid_res2 = [res for res in res2 if res is not None]

        if len(valid_res2) != 0:
            res3 = pd.concat(valid_res2)
            for i in range(0, 16):
                print(res3[i])
            res3 = res3.drop([0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 14, 15, 16], axis=1)
            struct_conf_list = ["_struct_conf.conf_type_id", "_struct_conf.id"]
            res3.columns = res3.columns.tolist()[:7] + struct_conf_list
            results.append(res3)

        results2 = pd.concat(results)
        results2 = results2[results2["chrom"].notna()]
        # One-hot-encoding of structural conformation results
        results_encoded = pd.get_dummies(results2, columns=['_struct_conf.conf_type_id', '_struct_conf.id'], dtype=float)
        file_path = variantDir + "alpha_fold_pbd_struct_conf.txt"
        results_encoded.to_csv(file_path, mode="w", index=False, sep="\t")
