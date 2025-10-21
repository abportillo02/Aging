library(pheatmap)
library(readr)

# Load signal matrix
data <- read_csv("ZNF90_signal_matrix.csv")

# Convert to matrix format
mat <- matrix(data$Clipped_Score, nrow = 1)
colnames(mat) <- data$Element
rownames(mat) <- "ZNF90"

# Plot heatmap
pheatmap(mat,
         cluster_rows = FALSE,
         cluster_cols = TRUE,
         color = colorRampPalette(c("white", "blue"))(100),
         main = "ZNF90 ChIP-exo Signal over LTR7/HERVH")