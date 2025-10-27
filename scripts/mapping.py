from Bio import SeqIO
import os
input_fasta = "/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned.fasta"
output_dir = "/home/abportillo/github_repo/Aging/mafft"
os.makedirs(output_dir, exist_ok=True)

output_fasta = os.path.join(output_dir, "ltr7up_hervh_aligned_int.fasta")
mapping_file = os.path.join(output_dir, "name_mapping.tsv")

with open(input_fasta) as infile, open(output_fasta, "w") as outfile, open(mapping_file, "w") as mapfile:
    counters = {}  # Track counts per repeat type

    for record in SeqIO.parse(infile, "fasta"):
        full_header = record.description
        repeat_name = full_header.split("::")[0]  # Extract '7up1', '7up2', or 'HERVH'
        count = counters.get(repeat_name, 0)
        new_id = f"{repeat_name}_{count:04d}"
        counters[repeat_name] = count + 1

        # Write mapping: new ID to full original header
        mapfile.write(f"{new_id}\t{full_header}\n")

        # Update only the ID; preserve sequence exactly as-is
        record.id = new_id
        record.description = ""
        SeqIO.write(record, outfile, "fasta")