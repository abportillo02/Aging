#!/bin/sh
#SBATCH --job-name=chipexo_bigwig_conversion
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16
#SBATCH -N 1
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00
#SBATCH --output=/home/abportillo/github_repo/Aging/chip-fastq/rnapreprocess/bigwig/chipexo_bigwig_conversion_%j.log

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

cd /home/abportillo/github_repo/Aging/chip-fastq/rnapreprocess/bams

for bam in *_sorted.bam; do
  base=$(basename "$bam" _sorted.bam)
  echo "Processing $bam"

  samtools index "$bam"

  bamCoverage \
    -b "$bam" \
    -o "/home/abportillo/github_repo/Aging/chip-fastq/rnapreprocess/bigwig/${base}.bw" \
    --binSize 1 \
    --normalizeUsing CPM \
    --extendReads \
    --ignoreDuplicates \
    --minMappingQuality 30
done
``