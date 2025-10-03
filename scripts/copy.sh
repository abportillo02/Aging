#!/bin/bash

# Source and destination directories
input="/net/nfs-irwrsrchnas01/labs/dschones/Seq/LaBarge-data/data/LEP"
output="/home/abportillo/github_repo/Aging/bz2"

# Create destination directory if it doesn't exist
mkdir -p "$output"

# Copy all .bz2 files
mkdir -p "$bz2"
find "$input" -type f -name "*.bz2" -exec cp {} "$output" \;