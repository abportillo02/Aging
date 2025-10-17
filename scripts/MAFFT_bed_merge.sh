#!/bin/bash
#SBATCH --job-name=merge_ltr7up_dmrs
#SBATCH --output=/home/abportillo/github_repo/Aging/mafft/merge_ltr7up_dmrs.out
#SBATCH --error=/home/abportillo/github_repo/Aging/mafft/merge_ltr7up_dmrs.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16 # Number of cores
#SBATCH -N 1-4 # Min - Max Nodes
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC


outdir="/home/abportillo/github_repo/Aging/mafft"
bedtools="/home/abportillo/.conda/envs/mamba_abner_BC/bin/bedtools"



# Step 1: Extract LTR7up coordinates
awk -F'\t' '$4 ~ /7up1/ {print $1"\t"$2"\t"$3}' /home/abportillo/github_repo/Aging/mafft/hg19-elife-datafile.txt > "${outdir}/ltr7up.bed"

# Step 2: Extract HERVH-DMRs coordinates
cut -f1-3 /home/abportillo/github_repo/Aging/mafft/HERVH-DMRs.bed > "${outdir}/hervh_dmrs.bed"

# Step 3: Combine and merge
cat "${outdir}/ltr7up.bed" "${outdir}/hervh_dmrs.bed" | sort -k1,1 -k2,2n | ${bedtools} merge > "${outdir}/merged.bed"

echo "Merged BED file created: ${outdir}/merged.bed"