#!/bin/bash
#SBATCH --job-name=prepare_matrix
#SBATCH --output=/home/abportillo/github_repo/Aging/overlap/matrix.out
#SBATCH --error=/home/abportillo/github_repo/Aging/overlap/matrix.err
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
COUNTS="/home/abportillo/github_repo/Aging/overlap/ZNF90_counts.txt"
OUTDIR="/home/abportillo/github_repo/Aging/overlap"


# Building matrix 
echo -e "KZFP\tLTR7up1\tLTR7up2\tHERVH" > matrix.txt
awk 'BEGIN{OFS="\t"} {a[$1]=$2} END{print "ZNF90", a["LTR7up1"], a["LTR7up2"], a["HERVH"]}'${COUNTS} >> ${OUTDIR}/matrix.txt

