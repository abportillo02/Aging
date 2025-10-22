#!/bin/bash

input="/home/abportillo/github_repo/Aging/mafft/trimmed_ltr7up_hervh_aligned.fasta"
output="/home/abportillo/github_repo/Aging/mafft/truncated_names.fasta"
mapping="/home/abportillo/github_repo/Aging/mafft/name_mapping.tsv"

> "$output"
> "$mapping"

declare -A name_count

while read line; do
    if [[ "$line" == ">"* ]]; then
        full=${line#>}
        family=$(echo "$full" | cut -d'_' -f1 | sed 's/LTR//')
        chr=$(echo "$full" | grep -o 'chr[^_]*' | sed 's/chr//')

        base="${family}_c${chr}"

        # Add suffix if name already used
        if [[ -n "${name_count[$base]}" ]]; then
            suffix=$(printf \\$(printf '%03o' $((97 + name_count[$base]))))  # a, b, c...
            short="${base:0:7}$suffix"
            name_count[$base]=$((name_count[$base] + 1))
        else
            short="${base:0:10}"
            name_count[$base]=1
        fi

        echo ">$short" >> "$output"
        echo -e "$short\t$full" >> "$mapping"
    else
        echo "$line" >> "$output"
    fi
done < "$input"