import json
import pandas as pd

# Load signal matrix
with open("/home/abportillo/github_repo/Aging/motif_binding/signal_matrix.json") as f:
    signal_matrix = json.load(f)

# Load mapping
mapping = {}
with open("/home/abportillo/github_repo/Aging/mafft/name_mapping.tsv") as f:
    for line in f:
        seq_id, name = line.strip().split()
        mapping[seq_id] = name

# Build labeled matrix
data = []
row_labels = []

for seq_id, signal in signal_matrix.items():
    if seq_id in mapping:
        subfamily = mapping[seq_id].split("_")[0]
        label = f"{subfamily}_{seq_id}"
        data.append(signal)
        row_labels.append(label)

# Pad all signal vectors to the same length
max_len = max(len(row) for row in data)
data_padded = [row + [0] * (max_len - len(row)) for row in data]

# Convert to DataFrame
df = pd.DataFrame(data_padded, index=row_labels)

# Save to TSV with proper column headers
df.columns = [f"pos_{i}" for i in range(df.shape[1])]
df.to_csv("/home/abportillo/github_repo/Aging/motif_binding/grouped_signal_matrix.tsv", sep="\t")
