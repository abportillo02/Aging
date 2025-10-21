#!/bin/bash
#SBATCH --job-name=mafft_alignment
#SBATCH --output=/home/abportillo/github_repo/Aging/mafft/mafft_alignment.out
#SBATCH --error=/home/abportillo/github_repo/Aging/mafft/mafft_alignment.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16
#SBATCH -N 1
#SBATCH -p all
#SBATCH --mem=50G
#SBATCH --time=12:00:00

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

export TMPDIR=/tmp  # or use /scratch if needed

mafft="/home/abportillo/.conda/envs/mamba_abner_BC/bin/mafft"

# Run MAFFT with input and output files explicitly
${mafft} --auto --thread 16 /home/abportillo/github_repo/Aging/mafft/cleaned_ltr7up_hervh.fasta \
> /home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned.fasta