#!/bin/bash

input="/net/nfs-irwrsrchnas01/labs/dschones/Seq/LaBarge-data/data/LEP"
output="/home/abportillo/github_repo/Aging/bz2"


mkdir -p "$output"

mkdir -p "$bz2"
find "$input" -type f -name "*.bz2" -exec cp {} "$output" \;