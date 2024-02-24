#!/bin/bash
# Script for downloading the Alpha Fold CIF files

wget https://ftp.ebi.ac.uk/pub/databases/alphafold/latest/UP000005640_9606_HUMAN_v4.tar
tar -xf UP000005640_9606_HUMAN_v4.tar

mkdir alphafold_files
rm *pdb*
cp *cif* alphafold_files
