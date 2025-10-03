#!/bin/bash
#SBATCH --job-name=RNA_pipeline
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=abportillo@coh.org
#SBATCH -n 16 # Number of cores
#SBATCH -N 1-4 # Min - Max Nodes
#SBATCH -p all
#SBATCH --mem=150G
#SBATCH --time=48:00:00

# Check for sample list argument
if [ -z "$1" ]; then
  echo "Usage: sbatch run_pipeline.sh <sampleNames.txt>"
  exit 1
fi

samples=$1

if [ ! -f "$samples" ]; then
  echo "Input file '$samples' not found!"
  exit 1
fi

# Define paths
datapath_aging=/home/abportillo/github_repo/Aging/bz2
base_outdir=${datapath_aging}/rnaPreprocess

# Create logs directory if it doesn't exist
mkdir -p logs

# Process each sample
while IFS= read -r sample_name; do
  echo "Processing sample: $sample_name"
  outdir=${base_outdir}/${sample_name}
  mkdir -p "$outdir"

  log_file="${outdir}/${sample_name}.log"

  {
    echo "=== STAR ==="
    bash scripts/STAR.sh "$sample_name" "$datapath_aging" "$outdir"

    echo "=== Sorting ==="
    bash scripts/sorting.sh "$sample_name" "$datapath_aging" "$outdir"

    echo "=== Split Strands ==="
    bash scripts/split_strands.sh "$sample_name" "$datapath_aging" "$outdir"

    echo "=== Coverage ==="
    bash scripts/coverage.sh "$sample_name" "$datapath_aging" "$outdir"

    echo "=== DONE ==="
  } &> "$log_file"

done < "$samples"

echo "All samples processed."