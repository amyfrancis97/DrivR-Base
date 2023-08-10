#!/bin/bash
#SBATCH --job-name=alpha_fold
#SBATCH --partition=mrcieu,short,test,compute
#SBATCH --mem=150G
#SBATCH --time=4-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG10_alpha_fold
#SBATCH --account=sscm013903

python get_alpha_fold_atom.py ${1} ${2}
