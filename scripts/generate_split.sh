#!/bin/bash
#SBATCH --job-name=generate_split
#SBATCH --output=generate_split.out
#SBATCH --error=generate_split.err
#SBATCH -n 1
#SBATCH --mem=10G
#SBATCH --time=01:00:00

module load python/3.9
source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

python generate_split.py