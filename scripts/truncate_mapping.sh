#!/bin/bash

input="/home/abportillo/github_repo/Aging/mafft/trimmed_ltr7up_hervh_aligned.fasta"
output="/home/abportillo/github_repo/Aging/mafft/truncated_names.fasta"
mapping="/home/abportillo/github_repo/Aging/mafft/name_mapping.tsv"

> "$output"
> "$mapping"

declare -A names

while read line; do
    if [[ "$line" == ">"* ]]; then
        full=${line#>}
        short=${full:0:10}

        if [[ -n "${names[$short]}" ]]; then
            count=${names[$short]}
            short="${short:0:9}$count"
            names[$short]=$((count + 1))
        else
            names[$short]=1
        fi

        echo ">$short" >> "$output"
        echo -e "$short\t$full" >> "$mapping"
    else
        echo "$line" >> "$output"
    fi
done < "$input"