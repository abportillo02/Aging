#!/bin/bash
#SBATCH --job-name=signal_overlap
#SBATCH --output=/home/abportillo/github_repo/Aging/overlap/signal_overlap.out
#SBATCH --error=/home/abportillo/github_repo/Aging/overlap/signal_overlap.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16
#SBATCH -N 1-4
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

CHIP_EXO="/net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/projects/PMM/chipExo/GSE78099/GSM2466684_ZNF90_peaks_processed_score_signal_exo.bed.gz"
SPLIT_FILE="/home/abportillo/github_repo/Aging/overlap/TE_split_full.txt"
BEDTOOLS="/home/abportillo/.conda/envs/mamba_abner_BC/bin/bedtools"
OUTDIR="/home/abportillo/github_repo/Aging/overlap"

# Step 1: Intersect TE regions with ChIP-exo peaks, keep all TE rows even if no overlap

${BEDTOOLS} intersect -a ${SPLIT_FILE} -b ${CHIP_EXO} -loj | \
awk 'BEGIN{OFS="\t"} {score=$11; if(score=="-1") score=0; print $1,$2,$3,$4,$5,score}' > ${OUTDIR}/temp-ZNF90.counts