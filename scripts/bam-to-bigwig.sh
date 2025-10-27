#!/bin/sh
#SBATCH --job-name=chipexo_bigwig_conversion
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16
#SBATCH -N 1-4
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00
#SBATCH --output=/home/abportillo/github_repo/Aging/chip-fastq/rnapreprocess/bigwig/chipexo_bigwig_conversion_%j.log

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

cd /home/abportillo/github_repo/Aging/chip-fastq/rnapreprocess/bams
chrom_sizes="/net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/hg38_2024/hg38_p14/filtered_hg38_p14.chrom.sizes"

for bam in *_sorted.bam; do
  base=$(basename "$bam" _sorted.bam)
  echo "Processing $bam"

  samtools index "$bam"
  bedtools genomecov -ibam "$bam" -bg > "${base}.bedGraph"
  bedGraphToBigWig "${base}.bedGraph" "$chrom_sizes" "/home/abportillo/github_repo/Aging/chip-fastq/rnapreprocess/bigwig/${base}.bw"
done