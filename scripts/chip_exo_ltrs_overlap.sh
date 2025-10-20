#!/bin/bash
#SBATCH --job-name=intersect_with_bed
#SBATCH --output=/home/abportillo/github_repo/Aging/overlap/overlap.out
#SBATCH --error=/home/abportillo/github_repo/Aging/overlap/overlap.err
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
CHIP_EXO="/net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/projects/PMM/chipExo/GSE78099/GSM2466684_ZNF90_peaks_processed_score_signal_exo.bed.gz"
MERGED_BED="/home/abportillo/github_repo/Aging/mafft/merged_ltrs_labeled.bed"
OUTDIR="/home/abportillo/github_repo/Aging/overlap"


# Intersect labeled LTRs with a KZFP ChIP-exo peak file 
$bedtools intersect -a ${MERGED_BED} -b ${CHIP_EXO} -wa -wb -loj \
| sed 's/-1/0/g' > "${OUTDIR}/ZNF90_LTR_overlap_full.bed"