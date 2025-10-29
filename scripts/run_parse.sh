#!/bin/bash
#SBATCH --job-name=parse_seq
#SBATCH --output=/home/abportillo/github_repo/Aging/motif_binding/parse_seq.out
#SBATCH --error=/home/abportillo/github_repo/Aging/motif_binding/parse_seq.err
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
python /home/abportillo/github_repo/Aging/scripts/parse_phylip_alignment.py

