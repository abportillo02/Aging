#!/bin/bash
#SBATCH --job-name=merge_ltr7up_dmrs
#SBATCH --output=/home/abportillo/github_repo/Aging/mafft/merge_ltr7up_dmrs_labeled.out
#SBATCH --error=/home/abportillo/github_repo/Aging/mafft/merge_ltr7up_dmrs_labeled.err
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


# Extract first 4 columns from hg19-elife-datafile.txt (LTR7up elements)
awk 'NR>1 {print $1"\t"$2"\t"$3"\tLTR" $4}' /home/abportillo/github_repo/Aging/mafft/hg19-elife-datafile.txt > "${outdir}/ltr7up_labeled.bed"

# Add "HERVH" label to all entries in HERVH-DMRs.bed
awk '{print $1"\t"$2"\t"$3"\tHERVH"}' /home/abportillo/github_repo/Aging/mafft/HERVH-DMRs.bed > "${outdir}/hervh_labeled.bed"

# Concatenate both into a unified BED file
cat ltr7up_labeled.bed hervh_labeled.bed > "${outdir}/merged_ltrs_labeled.bed"

echo "Merged BED file created: ${outdir}/merged_ltrs_labeled.bed"