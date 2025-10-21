from Bio import SeqIO
import pandas as pd
import os

outdir = "/home/abportillo/github_repo/Aging/plots"
fasta_file = "/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned.fasta"
bed_file = "/home/abportillo/github_repo/Aging/overlap/ZNF90_LTR_overlap_full.bed"
csv_output = os.path.join(outdir, "chip_exo_msa_matrix.csv")

# === Step 1: Parse aligned FASTA and initialize MSA matrix ===
msa_matrix = []
labels = []
position_maps = {}

with open(fasta_file) as handle:
    for record in SeqIO.parse(handle, "fasta"):
        seq_id = record.id
        sequence = str(record.seq)
        labels.append(seq_id)
        row = [0] * len(sequence)
        msa_matrix.append(row)

        genomic_offset = 0
        position_map = {}
        for msa_col, base in enumerate(sequence):
            if base != "-":
                position_map[genomic_offset] = msa_col
                genomic_offset += 1
        position_maps[seq_id] = position_map

# === Step 2: Read ChIP-exo BED overlaps and add signal ===
with open(bed_file) as bed:
    for line in bed:
        fields = line.strip().split("\t")
        if len(fields) < 11:
            continue
        ltr_chr, ltr_start = fields[0], int(fields[1])
        chip_chr, chip_start, chip_end, score = fields[5], int(fields[6]), int(fields[7]), float(fields[9])

        if chip_chr == "." or score == 0:
            continue

        for i, label in enumerate(labels):
            if ltr_chr in label and str(ltr_start) in label:
                for pos in range(chip_start, chip_end):
                    rel_pos = pos - ltr_start
                    if rel_pos in position_maps[label]:
                        msa_col = position_maps[label][rel_pos]
                        msa_matrix[i][msa_col] += score
                break
# === Step 3: Save matrix for R ===
msa_df = pd.DataFrame(msa_matrix, index=labels)
msa_df.to_csv(csv_output)
print(f"MSA signal matrix saved to {csv_output} for R heatmap visualization.")