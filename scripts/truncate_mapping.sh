#!/bin/bash

input="/home/abportillo/github_repo/Aging/mafft/trimmed_ltr7up_hervh_aligned.fasta"
output="/home/abportillo/github_repo/Aging/mafft/truncated_names.fasta"
mapping="/home/abportillo/github_repo/Aging/mafft/name_mapping.tsv"

> "$output"
> "$mapping"

while read line; do
    if [[ "$line" == ">"* ]]; then
        full=${line#>}
        name=$(echo "$full" | cut -d'_' -f1)      # e.g., LTR7up1 or HERVH
        chr=$(echo "$full" | grep -o 'chr[^_]*')  # e.g., chr8, chrX

        short="${name}_c${chr#chr}"               # e.g., LTR7up1_c8

        # truncate to 10 characters if needed
        short="${short:0:10}"

        echo ">$short" >> "$output"
        echo -e "$short\t$full" >> "$mapping"
    else
        echo "$line" >> "$output"
    fi
done < "$input"