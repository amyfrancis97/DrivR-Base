#!/bin/bash

# Create a Conda environment
conda env create --name DrivR-Base --file=DrivR-Base.yml

# Activate the Conda environment
conda activate DrivR-Base

echo "Conda environment created and packages installed."

