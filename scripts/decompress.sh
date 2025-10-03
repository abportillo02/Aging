#!/bin/bash

input="/home/abportillo/github_repo/Aging/bz2"
output="/home/abportillo/github_repo/Aging/fastq"

mkdir -p "$output"

find "$input" -type f -name "*.fastq.bz2" | parallel 'bunzip2 -c {} > "$output/{/%.bz2}"'
