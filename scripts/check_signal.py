import json

with open("/home/abportillo/github_repo/Aging/motif_binding/signal_matrix.json") as f:
    signal_matrix = json.load(f)

has_signal = any(any(val > 0 for val in signal_vector) for signal_vector in signal_matrix.values())
print("Signal detected in matrix." if has_signal else "No signal detected in matrix.")