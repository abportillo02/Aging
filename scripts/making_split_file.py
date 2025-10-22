
import re

with open("/home/abportillo/github_repo/Aging/mafft/ltr7up_hervh_aligned.fasta") as fasta, open("home/abportillo/github_repo/Aging/mafft/split_file.tsv", "w") as out:
    for line in fasta:
        if line.startswith(">"):
            header = line.strip()[1:]
            match = re.search(r"(chr[\w]+):(\d+)-(\d+)", header)
            if match:
                chrom, start, end = match.groups()
                out.write(f"{header}\t{chrom}\t{start}\t{end}\n")