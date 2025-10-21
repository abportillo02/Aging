from Bio import SeqIO
import pandas as pd
import plotly.express as px
import os
outdir = "/home/abportillo/github_repo/Aging/plots"

# === Step 1: Parse aligned FASTA and initialize MSA matrix ===
msa_matrix = []
labels = []
position_maps = {}  # {seq_id: {genomic_offset: msa_col}}

with open("/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned.fasta") as handle:
    for record in SeqIO.parse(handle, "fasta"):
        seq_id = record.id
        sequence = str(record.seq)
        labels.append(seq_id)
        row = [0] * len(sequence)
        msa_matrix.append(row)

        # Build genomic offset -> MSA column mapping
        genomic_offset = 0
        position_map = {}
        for msa_col, base in enumerate(sequence):
            if base != "-":
                position_map[genomic_offset] = msa_col
                genomic_offset += 1
        position_maps[seq_id] = position_map

# === Step 2: Read ChIP-exo BED overlaps and add signal ===
with open("/home/abportillo/github_repo/Aging/overlap/ZNF90_LTR_overlap_full.bed") as bed:
    for line in bed:
        fields = line.strip().split("\t")
        if len(fields) < 11:
            continue
        ltr_chr, ltr_start, ltr_end, ltr_id = fields[0], int(fields[1]), int(fields[2]), fields[3]
        chip_chr, chip_start, chip_end, peak_id, score, strand = fields[5], int(fields[6]), int(fields[7]), fields[8], float(fields[9]), fields[10]

        if chip_chr == "." or score == 0:
            continue

        # Find matching sequence in FASTA labels
        for i, label in enumerate(labels):
            if ltr_chr in label and str(ltr_start) in label:
                # Map each base in overlap to MSA column
                for pos in range(chip_start, chip_end):
                    rel_pos = pos - ltr_start
                    if rel_pos in position_maps[label]:
                        msa_col = position_maps[label][rel_pos]
                        msa_matrix[i][msa_col] += score
                break

# === Step 3: Convert to DataFrame and plot heatmap ===
msa_df = pd.DataFrame(msa_matrix, index=labels)
fig = px.imshow(msa_df,
                labels=dict(x="MSA Position", y="LTR7/HERVH Element", color="ChIP-exo Signal"),
                aspect="auto",
                color_continuous_scale="Reds")
fig.write_image(f"{outdir}/chip_exo_heatmap.png")
print("Heatmap saved as chip_exo_heatmap.png")