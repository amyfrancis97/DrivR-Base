import pandas as pd
import requests
import os
import sys
import numpy as np

def getAlphaFoldScores(variantVEPresults, df4):
    # Replace the URL with the actual URL of the text file
    #url = "https://alphafold.ebi.ac.uk/files/AF-" + df3["trembl"][variantVEPresults] + "-F1-model_v4.pdb"
    if df4["trembl"][variantVEPresults] is not None:
        url = "https://alphafold.ebi.ac.uk/files/AF-" + df4["trembl"][variantVEPresults] + "-F1-model_v4.cif"
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

if __name__ == "__main__":
    variantDir = sys.argv[1]
    variants = variantDir + sys.argv[2]
    chunksize = 10000
    for chunk in  pd.read_csv(variants + "_variant_effect_output_all.txt", sep = "\t", header = None, low_memory=False, chunksize=chunksize):
        df2 = chunk[7].str.split("ENST", expand = True)[1].str.split("|", expand = True)
        uniparc = df2[19].str.split(".", expand = True)[0]
        uniprot = df2[20].str.split(".", expand = True)[0]
        trembl = df2[18].str.split(".", expand = True)[0]
        swissprot = df2[17].str.split(".", expand = True)[0]
        proteinPosition = df2[8]
        gene = chunk[7].str.split("ENST", expand = True)[0].str.split("|", expand = True)[3]
        df3 = pd.concat([chunk.iloc[:, :7], gene, uniprot, uniparc, trembl, swissprot, proteinPosition], axis =1)
        df3 = df3.drop(2, axis = 1)
        df3.columns = ["chrom", "pos", "ref_allele", "alt_allele", "R", "driver_stat", "gene", "uniprot", "uniparc", "trembl", "swissprot", "protein_position"]
        # only retreive info for those with protein position
        df4 = df3[(df3["protein_position"] != "") & (df3["trembl"] != "") & (df3["trembl"] != np.nan) & (df3["protein_position"] != np.nan)].reset_index(drop = True)
        print(df4)
        res2 = [getAlphaFoldScores(i, df4) for i in range(0, len(df4))]
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
            file_path = variantDir + "alpha_fold_pbd_atom_site.txt"
            if os.path.exists(file_path):
                res4.to_csv(file_path, mode= "a", index=False, sep = "\t", header = None)
            else:
                res4.to_csv(file_path, mode= "w", index=False, sep = "\t")
