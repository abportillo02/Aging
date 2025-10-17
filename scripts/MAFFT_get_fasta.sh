#!/bin/bash
#SBATCH --job-name=bed_to_fasta
#SBATCH --output=/home/abportillo/github_repo/Aging/mafft/bed_to_fasta.out
#SBATCH --error=/home/abportillo/github_repo/Aging/mafft/bed_to_fasta.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16 # Number of cores
#SBATCH -N 1-4 # Min - Max Nodes
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

BEDTOOLS="/home/abportillo/.conda/envs/mamba_abner_BC/bin/bedtools"
REFERENCE_FASTA="/home/abportillo/genomes/hg19/hg19.fa"
MERGED_BED="/home/abportillo/github_repo/Aging/mafft/merged.bed"
OUTDIR="/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh.fasta"

${BEDTOOLS} getfasta -fi ${REFERENCE_FASTA} -bed ${MERGED_BED} -fo ${OUTDIR} -name

