#!/bin/bash

input="/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned.fasta"
output="/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned_int.fasta"
mapping="/home/abportillo/github_repo/Aging/mafft/name_mapping.tsv"

> "$output"
> "$mapping"

count=1

while read line; do
    if [[ "$line" == ">"* ]]; then
        full=${line#>}
        short=$(printf "seq%04d" $count)
        echo ">$short" >> "$output"
        echo -e "$short\t$full" >> "$mapping"
        count=$((count + 1))
    else
        echo "$line" >> "$output"
    fi
done < "$input"