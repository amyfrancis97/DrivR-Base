#!/bin/sh

# Specify which directory you would like to download the ENCODE files into (requires a large amount of memory)
download_dir="/opt/vep/.vep/encode_data/"
mkdir -p $download_dir
export download_dir

# Specify working directory where scripts are located 
working_dir="/opt/vep/.vep/FG9_encode/"
export working_dir

