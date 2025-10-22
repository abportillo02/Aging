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
        count=${name_count[$base]:-1}
        name_count[$base]=$((count + 1))

        short="${base}${count}"
        short="${short:0:10}"  # final truncation to 10 characters

        echo ">$short" >> "$output"
        echo -e "$short\t$full" >> "$mapping"
    else
        echo "$line" >> "$output"
    fi
done < "$input"