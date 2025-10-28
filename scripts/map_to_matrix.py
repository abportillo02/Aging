import json
import pybedtools
import pyBigWig
from collections import defaultdict

# Load aligned sequences
with open("/home/abportillo/github_repo/Aging/motif_binding/aligned_sequences.json") as f:
    aligned_sequences = json.load(f)

# Load trimmed mapping file
seq_to_bed = {}
with open("/home/abportillo/github_repo/Aging/mafft/trimmed_name_mapping.tsv") as f:
    for line in f:
        seq_id, repeat_family, full_name = line.strip().split()
        coords = full_name.split("::")[1]
        chrom, positions = coords.split(":")
        start, end = map(int, positions.split("-"))
        seq_to_bed[seq_id] = (chrom, start, end, repeat_family)

# Load BED file (optional validation)
bed = pybedtools.BedTool("/home/abportillo/github_repo/Aging/mafft/merged_HERVH_LTR7up_hg38.bed")
bed_set = set((i.chrom, i.start, i.end, i.name) for i in bed)

# Load bigWig ChIP-exo signal file
bw = pyBigWig.open("/home/abportillo/github_repo/Aging/chip-fastq/rnapreprocess/bigwig/SRR5197232.bw")

# Get signal vector per base from bigWig
def get_signal_vector(chrom, start, end, bw):
    try:
        signal = bw.values(chrom, start, end, numpy=False)
        return [0.0 if v is None else min(v, 30.0) for v in signal]  # saturate at 30
    except RuntimeError:
        return [0.0] * (end - start)

# Map signal to aligned sequence
def map_signal_to_alignment(aligned_seq, signal_vector):
    aligned_signal = []
    seq_index = 0
    for base in aligned_seq:
        if base == "-":
            aligned_signal.append(0.0)
        else:
            if seq_index < len(signal_vector):
                aligned_signal.append(signal_vector[seq_index])
            else:
                aligned_signal.append(0.0)
            seq_index += 1
    return aligned_signal
# Build signal matrix
signal_matrix = {}

for seq_id, aligned_seq in aligned_sequences.items():
    if seq_id not in seq_to_bed:
        signal_matrix[seq_id] = [0.0] * len(aligned_seq)
        continue

    chrom, start, end, repeat_family = seq_to_bed[seq_id]
    signal_vector = get_signal_vector(chrom, start, end, bw)
    aligned_signal = map_signal_to_alignment(aligned_seq, signal_vector)
    signal_matrix[seq_id] = aligned_signal

# Diagnostics
all_signals = [val for row in signal_matrix.values() for val in row]
print(f"Non-zero positions: {sum(1 for v in all_signals if v > 0)}")
print(f"Max score: {max(all_signals)}")
print(f"Mean score: {sum(all_signals)/len(all_signals):.2f}")

# Save signal matrix
with open("/home/abportillo/github_repo/Aging/motif_binding/signal_matrix_75D.json", "w") as f:
    json.dump(signal_matrix, f, indent=2)

bw.close()
print("Signal matrix saved to motif_binding/signal_matrix_75D.json")