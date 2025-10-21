#!/bin/bash
#SBATCH --job-name=chip_exo_overlay
#SBATCH --output=/home/abportillo/github_repo/Aging/overlap/chip_exo_overlay.out
#SBATCH --error=/home/abportillo/github_repo/Aging/overlap/chip_exo_overlay.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16
#SBATCH -N 1
#SBATCH -p all
#SBATCH --mem=50G
#SBATCH --time=12:00:00

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC
OUTDIR="/home/abportillo/github_repo/Aging/overlap"

# Intersect ChIP-exo with LTR7/HERVH using bedtools
bedtools intersect -a /net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/projects/PMM/chipExo/GSE78099/GSM2466684_ZNF90_peaks_processed_score_signal_exo.bed.gz \
                   -b /home/abportillo/github_repo/Aging/mafft/merged_ltrs_labeled.bed \
                   -wa -wb > ${OUTDIR}/ZNF90_LTR7HERVH_intersect.bed

# Run Python script
python3 overlay_chip_exo_signal.py

