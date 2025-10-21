#!/usr/bin/env python

OUTDIR = "/home/abportillo/github_repo/Aging/overlap"

from Bio import AlignIO

alignment = AlignIO.read("/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned.fasta", "fasta")
size = alignment.get_alignment_length()

with open(f"{OUTDIR}/TE_split.txt", "w") as out:
    for record in alignment:
        for i in range(size):
            out.write(f"{record.id}\t{i}\n")