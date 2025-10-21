library(pheatmap)
mat <- read.table("ZNF90.ordered.matrix", header=FALSE, row.names=1)
mat_norm <- t(scale(t(mat)))  # z-score per TE
pheatmap(mat_norm,
         cluster_rows=TRUE,
         cluster_cols=FALSE,
         color=colorRampPalette(c("blue","white","red"))(100),
         show_rownames=FALSE,
         main="Base-resolution ChIP-exo Signal Across TE Alignment")