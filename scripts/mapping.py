from Bio import SeqIO

mapping = {}
msa_matrix = []
labels = []

with open("/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned.fasta") as handle:
    for record in SeqIO.parse(handle, "fasta"):
        seq_id = record.id
        sequence = str(record.seq)
        labels.append(seq_id)
        row = []
        genomic_pos = 0
        for base in sequence:
            if base == "-":
                row.append(0)  # gap
            else:
                row.append(0)  # placeholder for signal
                genomic_pos += 1
        msa_matrix.append(row)