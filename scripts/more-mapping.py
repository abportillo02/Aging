from Bio import SeqIO
import pandas as pd

# Input files
trimmed_fasta = "/home/abportillo/github_repo/Aging/mafft/trimmed_ltr7up_hervh_aligned.fasta"
original_mapping = "/home/abportillo/github_repo/Aging/mafft/name_mapping.tsv"
output_fasta = "/home/abportillo/github_repo/Aging/mafft/trimmed_ltr7up_hervh_aligned_unique.fasta"
output_mapping = "/home/abportillo/github_repo/Aging/mafft/trimmed_name_mapping.tsv"

# Load original mapping: seqXXXX -> full header
orig_map = pd.read_csv(original_mapping, sep="\t", header=None, names=["short", "original"])
orig_map_dict = dict(zip(orig_map["short"], orig_map["original"]))

# Process trimmed FASTA
with open(trimmed_fasta) as infile, open(output_fasta, "w") as out_fasta, open(output_mapping, "w") as out_map:
    for i, record in enumerate(SeqIO.parse(infile, "fasta")):
        trimmed_header = record.id
        new_id = f"seq{i+1:04d}"

        # Lookup full original header using new_id
        original_header = orig_map_dict.get(new_id, "NA")

        # Write new FASTA
        record.id = new_id
        record.description = ""
        out_fasta.write(record.format("fasta"))

        # Write mapping
        out_map.write(f"{new_id}\t{trimmed_header}\t{original_header}\n")