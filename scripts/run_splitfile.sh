#!/bin/bash
#SBATCH --job-name=splitfile
#SBATCH --output=/home/abportillo/github_repo/Aging/mafft/splitfile.out
#SBATCH --error=/home/abportillo/github_repo/Aging/mafft/splitfile.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16 # Number of cores
#SBATCH -N 1-4 # Min - Max Nodes
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

# Run Python script
python making_split_file.py

