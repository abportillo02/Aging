import json
import pandas as pd
import math

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
groups = []

for seq_id, signal in signal_matrix.items():
    if seq_id in mapping:
        subfamily = mapping[seq_id].split("_")[0]
        label = f"{subfamily}_{seq_id}"
        log_signal = [math.log2(x + 1) for x in signal]  # log normalization
        data.append(log_signal)
        row_labels.append(label)
        groups.append(subfamily)

# Sort by group
sorted_indices = sorted(range(len(groups)), key=lambda i: groups[i])
data = [data[i] for i in sorted_indices]
row_labels = [row_labels[i] for i in sorted_indices]
groups = [groups[i] for i in sorted_indices]

# Pad all signal vectors to the same length
max_len = max(len(row) for row in data)
data_padded = [row + [0] * (max_len - len(row)) for row in data]

# Convert to DataFrame
df = pd.DataFrame(data_padded, index=row_labels)
df.columns = [f"pos_{i}" for i in range(df.shape[1])]
df['group'] = groups  # Add group column

# Save to TSV
df.to_csv("/home/abportillo/github_repo/Aging/motif_binding/grouped_signal_matrix.tsv", sep="\t")

print("Grouped and log-normalized signal matrix saved.")