import json
import pandas as pd

# --- Load signal matrix and mapping ---
with open("signal_matrix.json") as f:
    signal_matrix = json.load(f)

mapping = {}
with open("name_mapping.tsv") as f:
    for line in f:
        seq_id, name = line.strip().split()
        mapping[seq_id] = name

# --- Extract subfamily and build labeled matrix ---
data = []
row_labels = []

for seq_id, signal in signal_matrix.items():
    name = mapping.get(seq_id, "")
    subfamily = name.split("_")[0]
    label = f"{subfamily}_{seq_id}"
    data.append(signal)
    row_labels.append(label)

# --- Convert to DataFrame and save ---
df = pd.DataFrame(data, index=row_labels)
df.to_csv("grouped_signal_matrix.tsv", sep="\t")
