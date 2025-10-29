from Bio import SeqIO
import os

input_fasta = "/home/abportillo/github_repo/Aging/mafft/dmr_ltr7_hervh_aligned.fasta"
output_dir = "/home/abportillo/github_repo/Aging/mafft"
os.makedirs(output_dir, exist_ok=True)

output_fasta = os.path.join(output_dir, "dmr_ltr7_hervh_aligned.fasta")
mapping_file = os.path.join(output_dir, "name_mapping.tsv")

with open(input_fasta) as infile, open(output_fasta, "w") as outfile, open(mapping_file, "w") as mapfile:
    count = 1

    for record in SeqIO.parse(infile, "fasta"):
        full_header = record.description
        new_id = f"seq{count:04d}"
        count += 1

        mapfile.write(f"{new_id}\t{full_header}\n")
        record.id = new_id
        record.description = ""
        outfile.write(record.format("fasta"))  # preserves alignment formatting