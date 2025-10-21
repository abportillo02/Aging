import pandas as pd

# Load intersected BED file (generated via bedtools)
overlap_df = pd.read_csv("/home/abportillo/github_repo/Aging/overlap/ZNF90_LTR7HERVH_intersect.bed", sep="\t", header=None)

# Clip signal at 30 reads/base
overlap_df[4] = overlap_df[4].clip(upper=30)

# Aggregate signal per LTR/HERVH element
signal_matrix = overlap_df.groupby(9)[4].sum().reset_index()
signal_matrix.columns = ["Element", "Clipped_Score"]

# Save to CSV
signal_matrix.to_csv("/home/abportillo/github_repo/Aging/overlap/ZNF90_signal_matrix.csv", index=False)