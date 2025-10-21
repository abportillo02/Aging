#!/usr/bin/env python
import sys
from Bio import AlignIO

bed_file = "/home/abportillo/github_repo/Aging/mafft/merged_ltrs_labeled.bed"
fasta_file = "/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned.fasta"
out_file = "/home/abportillo/github_repo/Aging/overlap/TE_split_full.txt"

# Read alignment
alignment = AlignIO.read(fasta_file, "fasta")
size = alignment.get_alignment_length()

# Read BED
bed_data = []
with open(bed_file) as bed:
    for line in bed:
        s = line.strip().split()
        bed_data.append((s[0], int(s[1]), int(s[2]), s[3]))  # chr, start, end, TE_name

# Generate split file
with open(out_file, "w") as out:
    for chr_, start, end, te_name in bed_data:
        length = end - start
        step = length / size
        for i in range(size):
            pos_start = int(start + i * step)
            pos_end = pos_start + 1
            out.write(f"{chr_}\t{pos_start}\t{pos_end}\t{i}\t{te_name}\n")