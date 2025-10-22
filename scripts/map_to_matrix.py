import json
import pybedtools
from collections import defaultdict

# --- Load aligned sequences ---
with open("/home/abportillo/github_repo/Aging/motif_binding/aligned_sequences.json") as f:
    aligned_sequences = json.load(f)

# --- Load mapping file (seq000X → LTR7up1_chr8) ---
mapping = {}
with open("/home/abportillo/github_repo/Aging/mafft/name_mapping.tsv") as f:
    for line in f:
        seq_id, name = line.strip().split()
        mapping[seq_id] = name

# --- Load BED file with genomic coordinates ---
bed = pybedtools.BedTool("/home/abportillo/github_repo/Aging/mafft/merged_ltrs_labeled_named.bed")

# Build lookup: {name: list of (chrom, start, end)}
bed_lookup = defaultdict(list)
for interval in bed:
    name = interval.name.split(":")[0]
    bed_lookup[name].append((interval.chrom, interval.start, interval.end))

# --- Load ChIP-exo signal BED file ---
chip_bed = pybedtools.BedTool("/net/nfs-irwrsrchnas01/labs/dschones/bioresearch/qianhui/projects/PMM/chipExo/GSE78099/GSM2466684_ZNF90_peaks_processed_score_signal_exo.bed.gz")

# --- Get signal vector per base ---
def get_signal_vector(chrom, start, end, chip_bed):
    region = pybedtools.BedTool([pybedtools.create_interval_from_list([chrom, str(start), str(end)])])
    signal = chip_bed.intersect(region, wa=True)

    signal_vector = [0] * (end - start)
    for interval in signal:
        for i in range(interval.start, interval.end):
            if start <= i < end:
                signal_vector[i - start] = min(signal_vector[i - start] + 1, 30)
    return signal_vector

# --- Map signal to aligned sequence ---
def map_signal_to_alignment(aligned_seq, signal_vector):
    aligned_signal = []
    seq_index = 0
    for base in aligned_seq:
        if base == "-":
            aligned_signal.append(0)
        else:
            if seq_index < len(signal_vector):
                aligned_signal.append(signal_vector[seq_index])
            else:
                aligned_signal.append(0)  # fallback if signal_vector is too short
            seq_index += 1
    return aligned_signal

# --- Build signal matrix ---
signal_matrix = {}

ordered_names = [mapping[seq_id] for seq_id in aligned_sequences]

for i, seq_id in enumerate(aligned_sequences):
    name = ordered_names[i]

    if name not in bed_lookup or i >= len(bed_lookup[name]):
        aligned_signal = [0] * len(aligned_sequences[seq_id])
    else:
        chrom, start, end = bed_lookup[name][i]
        signal_vector = get_signal_vector(chrom, start, end, chip_bed)
        aligned_signal = map_signal_to_alignment(aligned_sequences[seq_id], signal_vector)

    signal_matrix[seq_id] = aligned_signal


# Save signal matrix to a file
with open("/home/abportillo/github_repo/Aging/motif_binding/signal_matrix.json", "w") as f:
    json.dump(signal_matrix, f, indent=2)

print("Signal matrix saved to motif_binding/signal_matrix.json")