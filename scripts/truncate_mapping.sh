#!/bin/bash

input="/home/abportillo/github_repo/Aging/mafft/trimmed_ltr7up_hervh_aligned.fasta"
output="/home/abportillo/github_repo/Aging/mafft/truncated_names.fasta"
mapping="/home/abportillo/github_repo/Aging/mafft/name_mapping.tsv"

> "$output"
> "$mapping"

while read line; do
    if [[ "$line" == ">"* ]]; then
        full=${line#>}
        family=$(echo "$full" | cut -d'_' -f1 | sed 's/LTR//')  # remove LTR prefix
        chr=$(echo "$full" | grep -o 'chr[^_]*' | sed 's/chr//')  # extract chromosome

        short="${family}_c${chr}"
        short="${short:0:10}"  # truncate to 10 characters if needed

        echo ">$short" >> "$output"
        echo -e "$short\t$full" >> "$mapping"
    else
        echo "$line" >> "$output"
    fi
done < "$input"