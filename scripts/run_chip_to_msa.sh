#!/bin/bash
#SBATCH --job-name=chiptomsa
#SBATCH --output=chiptomsa.out
#SBATCH --error=chiptomsa.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16 # Number of cores
#SBATCH -N 1-4 # Min - Max Nodes
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00


source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

python map_chip_exo_to_msa.py