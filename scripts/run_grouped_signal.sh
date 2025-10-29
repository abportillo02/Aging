#!/bin/bash
#SBATCH --job-name=grouped_signal
#SBATCH --output=/home/abportillo/github_repo/Aging/motif_binding/grouped_signal.out
#SBATCH --error=/home/abportillo/github_repo/Aging/motif_binding/grouped_signal.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16
#SBATCH -N 1
#SBATCH -p all
#SBATCH --mem=50G
#SBATCH --time=12:00:00

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC



# Run Python script
python /home/abportillo/github_repo/Aging/scripts/grouped_signal.py
