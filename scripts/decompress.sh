#!/bin/bash

input="/home/abportillo/github_repo/Aging/bz2"

# Decompress all .fastq.bz2 files in the input directory
find "$input" -type f -name "*.fastq.bz2" | parallel --bar 'bunzip2 {}'