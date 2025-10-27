#!/bin/bash

source /home/abportillo/.bashrc
conda activate /home/abportillo/.conda/envs/mamba_abner_BC

cd /home/abportillo/github_repo/Aging/chip-fastq/rnapreprocess/bams
chrom_sizes="/net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/hg38_2024/hg38_p14/filtered_hg38_p14.chrom.sizes"  # Update if needed

for bam in *_sorted.bam; do
  base=$(basename "$bam" _sorted.bam)
  echo "Processing $bam"

  # Index BAM
  samtools index "$bam"

  # Generate bedGraph
  bedtools genomecov -ibam "$bam" -bg > "${base}.bedGraph"

  # Convert to bigWig
  bedGraphToBigWig "${base}.bedGraph" "$chrom_sizes" "${base}.bw"
done