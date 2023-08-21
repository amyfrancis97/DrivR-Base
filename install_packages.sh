#!/bin/bash

# Create a Conda environment
conda create -n DrivR-Base python=3.8

# Activate the Conda environment
conda activate my_python_env

# Install packages
conda install -c conda-forge pandas=1.2.5 numpy=1.21.2 scikit-learn=0.24.2 biopython=1.79 matplotlib=3.4.3 strkernel=0.3.1 joblib=1.0.1

echo "Conda environment created and packages installed."

