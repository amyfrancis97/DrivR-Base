#!/bin/bash
#SBATCH --job-name=alpha_fold
#SBATCH --partition=mrcieu,short,test,compute
#SBATCH --mem=150G
#SBATCH --time=4-00:00:0
#SBATCH --chdir=/user/home/uw20204/DrivR-Base/FG10_alpha_fold
#SBATCH --account=sscm013903

#tail -n +6 /bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/cosmicSomaMutDB.bed_variant_effect_output_all.txt > /bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/cosmicSomaMutDB.bed_variant_effect_output_all.tmp
#mv /bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/cosmicSomaMutDB.bed_variant_effect_output_all.tmp /bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/cosmicSomaMutDB.bed_variant_effect_output_all.txt 

#python get_alpha_fold_scores.py "/bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/" "cosmicSomaMutDB.bed"
python get_alpha_fold_struct_conf.py "/bp1/mrcieu1/data/encode/public/cosmic_somaMutDB_features/" "cosmicSomaMutDB.bed"
