#!/bin/bash
#SBATCH --job-name=sra_download
#SBATCH --output=sra_download.out
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16 # Number of cores
#SBATCH -N 1-4 # Min - Max Nodes
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00

# Load Conda environment
source /home/abportillo/.bashrc
conda activate mamba_abner_BC

# Output directory
output_dir="/home/abportillo/github_repo/Aging/chip-fastq"
mkdir -p "$output_dir"

# SRA IDs
sra_ids="/home/abportillo/github_repo/Aging/ZNF_HERVH_SRA.txt"

# Loop through and download each
while read -r sra; do
  echo "Downloading $sra..."
  fasterq-dump "$sra" -O "$output_dir" -e 4
done < "$sra_ids"


echo "All downloads complete."