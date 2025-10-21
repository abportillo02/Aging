#!/bin/bash
#SBATCH --job-name=generate_split
#SBATCH --output=generate_split.out
#SBATCH --error=generate_split.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16 # Number of cores
#SBATCH -N 1-4 # Min - Max Nodes
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00

module load python/3.9
source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

python TE_split_file_1.py