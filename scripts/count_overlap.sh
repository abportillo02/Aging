#!/bin/bash
#SBATCH --job-name=count_overlaps
#SBATCH --output=/home/abportillo/github_repo/Aging/overlap/count_overlap.out
#SBATCH --error=/home/abportillo/github_repo/Aging/overlap/count_overlap.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16 # Number of cores
#SBATCH -N 1-4 # Min - Max Nodes
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00


source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

ZNF90_BED="/home/abportillo/github_repo/Aging/overlap/ZNF90_LTR_overlap.bed"
OUTDIR="/home/abportillo/github_repo/Aging/overlap"

# Counting overlaps 
cut -f4 ${ZNF90_BED} | sort | uniq -c | awk '{print $2"\t"$1}' > "${OUTDIR}/ZNF90_counts.txt"

