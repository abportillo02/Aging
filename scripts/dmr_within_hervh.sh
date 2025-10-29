#!/bin/bash
#SBATCH --job-name=DMR_HERVH
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH --output=/home/abportillo/github_repo/Aging/mafft/DMR_HERVH.out
#SBATCH --error=/home/abportillo/github_repo/Aging/mafft/DMR_HERVH.err
#SBATCH -n 16
#SBATCH -N 1
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00

# Environment setup
source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

outdir="/home/abportillo/github_repo/Aging/mafft"
bedtools="/home/abportillo/.conda/envs/mamba_abner_BC/bin/bedtools"

# Input files
DMR_FILE="${outdir}/HERVH-DMRs_hg38.bed"
HERVH_FILE="/home/abportillo/github_repo/seq-align/all_HERVH.bed"

# Output files
DMR_SORTED="${outdir}/HERVH-DMRs_hg38.sorted.bed"
HERVH_SORTED="${outdir}/all_HERVH.sorted.bed"
HERVH_CONTAIN_DMR="${outdir}/HERVH_containing_DMR.bed"
FINAL_OUTPUT="${outdir}/DMR_HERVH_named.bed"

echo ">>> Sorting input BED files..."
sort -k1,1 -k2,2n "$DMR_FILE" > "$DMR_SORTED"
sort -k1,1 -k2,2n "$HERVH_FILE" > "$HERVH_SORTED"

echo ">>> Finding HERVH elements that fully contain DMRs..."
${bedtools} intersect -a "$HERVH_SORTED" -b "$DMR_SORTED" -F 1.0 -u > "$HERVH_CONTAIN_DMR"

echo ">>> Labeling HERVHs as DMR-HERVH..."
awk 'BEGIN{OFS="\t"} {print $1, $2, $3, "DMR-HERVH"}' "$HERVH_CONTAIN_DMR" > "$FINAL_OUTPUT"

# echo ">>> Sorting and removing duplicates..."
# sort -u "$FINAL_OUTPUT" -o "$FINAL_OUTPUT"

echo ">>> Done!"
echo "Output saved as: $FINAL_OUTPUT"
