from Bio import AlignIO
import json
import os

# Define input and output paths
input_path = "/home/abportillo/github_repo/Aging/mafft/dmr_ltr7_hervh.phy"
output_dir = "/home/abportillo/github_repo/Aging/motif_binding"
output_file = os.path.join(output_dir, "aligned_sequences.json")

# Ensure output directory exists
os.makedirs(output_dir, exist_ok=True)

# Load the PHYLIP alignment file (relaxed format)
alignment = AlignIO.read(input_path, "phylip-relaxed")

# Convert to dictionary: {seq_id: aligned_sequence}
aligned_sequences = {record.id: str(record.seq) for record in alignment}

# Save to JSON file
with open(output_file, "w") as f:
    json.dump(aligned_sequences, f, indent=2)

# Print summary
print(f"Loaded {len(aligned_sequences)} sequences.")
print(f"Each sequence is {alignment.get_alignment_length()} bases long (including gaps).")
print(f"Aligned sequences saved to {output_file}.")