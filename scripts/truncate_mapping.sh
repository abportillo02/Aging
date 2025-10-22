#!/bin/bash

input="/home/abportillo/github_repo/Aging/mafft/trimmed_ltr7up_hervh_aligned.fasta"
output="/home/abportillo/github_repo/Aging/mafft/truncated_names.fasta"
mapping="/home/abportillo/github_repo/Aging/mafft/name_mapping.tsv"

> "$output"
> "$mapping"

declare -A used_names

while read line; do
    if [[ "$line" == ">"* ]]; then
        full_name="${line#>}"
        base="${full_name:0:10}"

        # Make sure the name is unique
        if [[ -n "${used_names[$base]}" ]]; then
            count=${used_names[$base]}
            new_name="${base:0:9}$count"
            used_names[$base]=$((count + 1))
        else
            new_name="$base"
            used_names[$base]=2
        fi

        echo ">$new_name" >> "$output"
        echo -e "$new_name\t$full_name" >> "$mapping"
    else
        echo "$line" >> "$output"
    fi
done < "$input"