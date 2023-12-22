import pandas as pd
import requests
import os
import sys
import numpy as np
from unipressed import IdMappingClient
import time
import re
from unipressed import IdMappingClient
#from unipressed import IdMappingError, IdMappingClientError

def getUniprotIDs(vep_dataset):
    """
    Extract UniProt IDs and related information from a VEP (Variant Effect Predictor) dataset.

    Parameters:
    - vep_dataset (str): Path to the VEP dataset file.

    Returns:
    - Tuple: A tuple containing two DataFrames - the first with UniProt IDs and the second with processed information.
    """
    # Check if the input parameter is valid
    if not vep_dataset or not os.path.isfile(vep_dataset):
        print("Invalid input: vep_dataset is empty or does not exist.")
        return None

    # Read the VEP dataset, skipping the first 5 lines
    df = pd.read_csv(vep_dataset, sep="\t", header=None, low_memory=False, skiprows=5)

    # Extract protein position and gene information
    df2 = df[7].str.split("ENST", expand=True)[1].str.split("|", expand=True)
    proteinPosition = df2[8]
    gene = df[7].str.split("ENST", expand=True)[0].str.split("|", expand=True)[3]

    # Create a new DataFrame (df3) with relevant columns
    df3 = df.iloc[:, :7]
    df3["gene"] = gene
    df3["protein_position"] = proteinPosition
    df3 = df3.drop(2, axis=1)
    df3.columns = ["chrom", "pos", "ref_allele", "alt_allele", "R", "driver_stat", "gene", "protein_position"]
    df3["uniprot_conversion"] = np.nan
    print(len(df3))
    # Filter rows where protein_position is not empty, "None", or NaN
    df3 = df3[df3["protein_position"].isin(["", "None", np.nan]) == False].reset_index(drop=True)
    print(len(df3))
    # Extract unique genes for UniProt ID conversion
    genes = df3["gene"].unique().tolist()
    print(len(genes))
    # Convert the list of genes to a string with curly braces
    genes_str = "{" + ", ".join(f'"{gene}"' for gene in genes) + "}"
    # Retrieve UniProt IDs using IdMappingClient
    try:
        request = IdMappingClient.submit(source="GeneCards", dest="UniProtKB", ids={genes_str})
        time.sleep(10)
        uniprotIDs = pd.DataFrame(list(request.each_result()))
        uniprotIDs.columns = ["gene", "uniprot_res"]
    except:
        print("Error in uniprot mapping")
        uniprotIDs = pd.DataFrame(columns=["gene", "uniprot_res"])
    print(len(uniprotIDs))
    # Return a tuple with UniProt IDs and the processed DataFrame
    return uniprotIDs, df3

def get_alpha_fold_atom(uniprot_id, df):
    """
    Get AlphaFold Atom Information for a UniProt ID

    This function takes a UniProt ID as input and retrieves relevant information from a CIF file associated with the AlphaFold protein structure prediction. It involves the following steps:

    Error Handling:
    - Handles FileNotFoundError if the CIF file is not found for the given UniProt ID.
    - Handles pd.errors.EmptyDataError if there is no data in the CIF file.
    - Catches other unexpected exceptions and prints an error message with details.

    Parameters:
    - uniprot_id (str): UniProt ID of the protein.

    Returns:
    - pd.DataFrame: DataFrame containing relevant information from the CIF file.
    """
    try:
        # Select rows from DataFrame where "uniprot_res" column matches the provided uniprot_id
        res = df[df["uniprot_res"] == uniprot_id].reset_index(drop=True)
        
        # Construct the path to the CIF file based on the uniprot_id
        cif_file_path = f"{alpha_fold_cif_location}/AF-{uniprot_id}-F1-model_v4.cif.gz"
        
        # Read the CIF file into a DataFrame with tab-separated values and no header
        cif_file = pd.read_csv(cif_file_path, sep="\t", header=None)

        # Initialize an empty DataFrame to store the results
        results = pd.DataFrame()

        if len(res) == 1:
            # If there is only one matching row in the DataFrame
            atom_mask = cif_file[0].str.contains("ATOM")  # Select rows with "ATOM"
            filtered_cif = cif_file[atom_mask][0]  # Extract column 0 from filtered rows
            position_mask = filtered_cif[filtered_cif.str.contains(res.loc[0, "protein_position"])]  # Select rows with protein position
            results = position_mask.str.split("?", expand=True)[1].to_string()  # Split and select the relevant column
            results = pd.DataFrame(" ".join(results.split()).split()).transpose().iloc[:, 1:6].reset_index(drop = True)
            res_protein_pos = res[res["protein_position"] == position].reset_index(drop = True)
            results = pd.concat([res_protein_pos[["chrom", "pos", "ref_allele", "alt_allele"]], results], axis=1)
        else:
            # If there are multiple rows with different protein positions
            results = []
            for position in res["protein_position"].tolist():
                atom_mask = cif_file[0].str.contains("ATOM")
                filtered_cif = cif_file[atom_mask][0]
                position_mask = filtered_cif[filtered_cif.str.contains(position)]
                cif_res = position_mask.str.split("?", expand=True)[1].to_string()
                cif_res = pd.DataFrame(" ".join(cif_res.split()).split()).transpose().iloc[:, 1:6].reset_index(drop = True)
                res_protein_pos = res[res["protein_position"] == position].reset_index(drop = True)
                cif_res = pd.concat([res_protein_pos[["chrom", "pos", "ref_allele", "alt_allele"]], cif_res], axis=1)
                results.append(cif_res)

            # Concatenate the results from multiple positions and drop any NaN values
            results = pd.concat(results)
        print(len(results))
        results = results.rename(columns = {1: "X_coordinate", 2: "Y_coordinate", 3: "Z_coordinate", 4: "atom_sit_occupancy", 5: "isotropic_temperature"})
        # Return the final DataFrame containing the results
        return results
    except:
        x="y"

def get_alpha_fold_struct(uniprot_id):
    """
    Get AlphaFold Atom Information for a UniProt ID

    This function takes a UniProt ID as input and retrieves relevant information from a CIF file associated with the AlphaFold protein structure prediction. It involves the following steps:

    Error Handling:
    - Handles FileNotFoundError if the CIF file is not found for the given UniProt ID.
    - Handles pd.errors.EmptyDataError if there is no data in the CIF file.
    - Catches other unexpected exceptions and prints an error message with details.

    Parameters:
    - uniprot_id (str): UniProt ID of the protein.

    Returns:
    - pd.DataFrame: DataFrame containing relevant information from the CIF file.
    """
    try:
        # Select rows from DataFrame where "uniprot_res" column matches the provided uniprot_id
        res = df[df["uniprot_res"] == uniprot_id].reset_index(drop=True)

        # Construct the path to the CIF file based on the uniprot_id
        cif_file_path = f"{alpha_fold_cif_location}/AF-{uniprot_id}-F1-model_v4.cif.gz"
        
        # Read the CIF file into a DataFrame with tab-separated values and no header
        cif_file = pd.read_csv(cif_file_path, sep="\t", header=None)

        # Initialize an empty DataFrame to store the results
        results = pd.DataFrame()

        if len(res) == 1:
            # If there is only one matching row in the DataFrame
            atom_mask = cif_file[0].str.contains("A ")  # Select rows with "ATOM"
            filtered_cif = cif_file[atom_mask][0]   # Extract column 0 from filtered rows
 
            atom_mask = filtered_cif.str.contains("\?") # Select rows with "ATOM"
            filtered_cif = filtered_cif[atom_mask]

            atom_mask = filtered_cif.str.contains("ATOM")
            filtered_cif = filtered_cif[~atom_mask]
            

            filtered_cif = filtered_cif[filtered_cif.str.contains(res.loc[0, "protein_position"])]


            filtered_cif = filtered_cif.str.split(expand = True).dropna()

            filtered_cif = filtered_cif.loc[filtered_cif[2] == res.loc[0, "protein_position"], [6, 13]].reset_index(drop = True)

            filtered_cif.columns = ["struct_conf_type", "struct_conf_type_ID"]

            results = pd.concat([res[["chrom", "pos", "ref_allele", "alt_allele"]].reset_index(drop = True), filtered_cif.reset_index(drop = True)], axis=1)

        else:
            # If there are multiple rows with different protein positions
            results = []
            for position in res["protein_position"].tolist():
                # If there is only one matching row in the DataFrame
                atom_mask = cif_file[0].str.contains("A ")  # Select rows with "A "
                filtered_cif = cif_file[atom_mask][0]   # Extract column 0 from filtered rows

                atom_mask = filtered_cif.str.contains("\?")
                filtered_cif = filtered_cif[atom_mask]
                atom_mask = filtered_cif.str.contains("ATOM")
                filtered_cif = filtered_cif[~atom_mask]
                filtered_cif = filtered_cif[filtered_cif.str.contains(position)]

                filtered_cif = filtered_cif.str.split(expand = True).dropna()
                filtered_cif = filtered_cif.loc[filtered_cif[2] == position, [6, 13]].reset_index(drop = True)

                filtered_cif.columns = ["struct_conf_type", "struct_conf_type_ID"]
                results = pd.concat([res[["chrom", "pos", "ref_allele", "alt_allele"]].reset_index(drop = True), filtered_cif.reset_index(drop = True)], axis=1)

            # Concatenate the results from multiple positions and drop any NaN values
            results = pd.concat(results).dropna()

        # Return the final DataFrame containing the results
        return results.dropna()

    except:
        x="y"

if __name__ == "__main__":
    variantDir = sys.argv[1]
    variants = sys.argv[3] + sys.argv[2]
    alpha_fold_cif_location = "/user/home/uw20204/DrivR-Base/alphafold_UP000005640_9606_HUMAN_v4"

    dataset = variants + "_variant_effect_output_all.txt"

    uniprotIDs, df3 = getUniprotIDs(dataset)

    df = pd.merge(df3, uniprotIDs, on = "gene", how = "left").drop("uniprot_conversion", axis =1)
    print(len(df))
    print(df.head())
    all_alphafold = [get_alpha_fold_atom(uniprot_id, df) for uniprot_id in df["uniprot_res"].unique()]
    all_alphafold = pd.concat(all_alphafold)

    struct_alphafold = [get_alpha_fold_struct(uniprot_id) for uniprot_id in df["uniprot_res"].unique()]
    struct_alphafold = pd.concat(struct_alphafold)

    # Get one hot encoding of columns B
    struct_conf_type = pd.get_dummies(struct_alphafold['struct_conf_type'])
    
    # Get one hot encoding of columns B
    struct_conf_type_ID = pd.get_dummies(struct_alphafold['struct_conf_type_ID'])

    # Drop column B as it is now encoded
    struct_alphafold = struct_alphafold.drop(['struct_conf_type', 'struct_conf_type_ID'],axis = 1)

    # Join the encoded df
    struct_alphafold = pd.concat([struct_alphafold, struct_conf_type, struct_conf_type_ID], axis = 1)
    print(sys.argv[3])
    all_alphafold.to_csv(sys.argv[3] + "alphafold_3D_coordinates.bed", sep = "\t", index = None)
    struct_alphafold.to_csv(sys.argv[3] + "alphafold_structural.bed", sep = "\t", index = None)
