# Load required libraries
library(apeglm)
library(DESeq2)
library(ggplot2)
library(pheatmap)

# ============================================
# STEP 1: Read the featureCounts file
# ============================================
count_data <- read.table("featurecounts_chr3.txt", 
                         header = TRUE, 
                         row.names = 1, 
                         comment.char = "#",
                         sep = "\t",
                         check.names = FALSE)

# View structure
cat("Original data dimensions:", dim(count_data), "\n")
cat("Column names:\n")
print(colnames(count_data))

# ============================================
# STEP 2: Extract count columns (skip first 6 annotation columns)
# ============================================
counts_only <- count_data[, 6:ncol(count_data), drop = FALSE]

cat("\nDimensions of counts_only:", dim(counts_only), "\n")
cat("Sample names before cleaning:\n")
print(colnames(counts_only))

# Clean column names
clean_names <- gsub(".*/", "", colnames(counts_only))
clean_names <- gsub("\\.sorted\\.bam$", "", clean_names)
clean_names <- gsub("X.proj.uppmax2026.1.61.nobackup.work.Manu.HISAT2.ASSAY.", "", clean_names)

colnames(counts_only) <- clean_names

cat("\nCleaned sample names:\n")
print(colnames(counts_only))

# ============================================
# STEP 3: Create colData (sample information)
# ============================================

colData <- data.frame(
  row.names = colnames(counts_only),
  condition = factor(c("control", "control", "control", "treated", "treated", "treated")),
  replicate = factor(c(1, 2, 3, 1, 2, 3))
)

# Add a descriptive name column
colData$sample_name <- rownames(colData)

cat("\ncolData created:\n")
print(colData)

# ============================================
# STEP 4: Create DESeq2 dataset (dds)
# ============================================
# Round counts to integers
counts_rounded <- round(counts_only)

# Remove genes with zero counts across all samples
counts_filtered <- counts_rounded[rowSums(counts_rounded) > 0, ]

cat("\nGenes after removing all-zero rows:", nrow(counts_filtered), "\n")

# Create the DESeqDataSet object
dds <- DESeqDataSetFromMatrix(
  countData = counts_filtered,
  colData = colData,
  design = ~ condition  # Compare treated vs control
)

cat("\nDESeqDataSet created successfully!\n")
print(dds)

# ============================================
# STEP 5: Pre-filtering (remove low count genes)
# ============================================
# Keep genes with at least 10 total reads across all samples
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

cat("\nGenes after pre-filtering (total count >= 10):", nrow(dds), "\n")

# ============================================
# STEP 6: Run DESeq2 analysis
# ============================================
cat("\nRunning DESeq2 analysis...\n")
dds <- DESeq(dds)
cat("Analysis complete!\n")

# ============================================
# STEP 7: Extract results
# ============================================
# Get results comparing treated vs control
res <- results(dds, contrast = c("condition", "treated", "control"))

# Order by adjusted p-value
res_ordered <- res[order(res$padj),]

# Summary of results
cat("\nResults summary:\n")
summary(res)

# Count significant genes
sig_genes <- sum(res$padj < 0.05, na.rm = TRUE)
cat("\nNumber of significant genes (padj < 0.05):", sig_genes, "\n")

# ============================================
# STEP 8: Shrunken log2 fold changes (for better visualization)
# ============================================
res_shrunk <- lfcShrink(dds, coef = resultsNames(dds)[2], type = "apeglm")

# ============================================
# STEP 9: Export results
# ============================================
setwd("~/Master_Bioinf/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/06_expression/DESeq2/Diagnostic_Plots")
write.csv(as.data.frame(res_ordered), "DESeq2_results_chr3.csv")
write.csv(as.data.frame(res_shrunk), "DESeq2_results_shrunk_chr3.csv")

# Export significant genes only
sig_genes_df <- as.data.frame(res_ordered[which(res_ordered$padj < 0.05), ])
write.csv(sig_genes_df, "DESeq2_significant_genes_chr3.csv")

# Export normalized counts
normalized_counts <- counts(dds, normalized = TRUE)
write.csv(as.data.frame(normalized_counts), "normalized_counts_chr3.csv")

# ============================================
# STEP 10: Diagnostic plots
# ============================================

# 1. PCA plot
vsd <- vst(dds, blind = FALSE)
pca_data <- plotPCA(vsd, intgroup = "condition", returnData = TRUE)
percentVar <- round(100 * attr(pca_data, "percentVar"))

pca_plot <- ggplot(pca_data, aes(x = PC1, y = PC2, color = condition)) +
  geom_point(size = 4) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  ggtitle("PCA Plot - Control vs Treated") +
  theme_minimal() +
  theme(legend.position = "bottom")

ggsave("PCA_plot_chr3.pdf", pca_plot, width = 8, height = 6)

# 2. Sample distance heatmap
sampleDists <- dist(t(assay(vsd)))
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(vsd$condition, vsd$replicate, sep = "-")
colnames(sampleDistMatrix) <- NULL

pdf("sample_distance_heatmap_chr3.pdf", width = 8, height = 6)
pheatmap(sampleDistMatrix,
         clustering_distance_rows = sampleDists,
         clustering_distance_cols = sampleDists,
         main = "Sample Distance Heatmap")
dev.off()

# 3. Volcano plot
res_df <- as.data.frame(res)
res_df$gene <- rownames(res_df)
res_df$significance <- "Not Significant"
res_df$significance[res_df$padj < 0.05 & !is.na(res_df$padj)] <- "Significant"
res_df$significance[res_df$padj < 0.01 & !is.na(res_df$padj)] <- "Highly Significant"

volcano_plot <- ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj), color = significance)) +
  geom_point(alpha = 0.6, size = 1) +
  scale_color_manual(values = c("Not Significant" = "gray", 
                                "Significant" = "blue", 
                                "Highly Significant" = "red")) +
  theme_minimal() +
  labs(title = "Volcano Plot - Treated vs Control",
       x = "Log2 Fold Change",
       y = "-Log10 Adjusted P-value") +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "gray") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "gray") +
  theme(legend.position = "bottom")

ggsave("volcano_plot_chr3.pdf", volcano_plot, width = 10, height = 8)

# 4. Heatmap of top 50 variable genes
top_var_genes <- head(order(rowVars(assay(vsd)), decreasing = TRUE), 50)
heatmap_data <- assay(vsd)[top_var_genes, ]

pdf("heatmap_top50_variable_genes_chr3.pdf", width = 10, height = 12)
pheatmap(heatmap_data,
         scale = "row",
         clustering_distance_rows = "correlation",
         clustering_distance_cols = "euclidean",
         show_rownames = TRUE,
         show_colnames = TRUE,
         main = "Top 50 Most Variable Genes",
         fontsize_row = 6)
dev.off()

# ============================================
# STEP 11: Save the dds object for later use
# ============================================
saveRDS(dds, "dds_object_chr3.rds")

# ============================================
# Final summary
# ============================================
cat("\n", rep("=", 50), "\n", sep="")
cat("ANALYSIS COMPLETE!\n")
cat(rep("=", 50), "\n", sep="")
cat("\nInput: featurecounts_chr3.txt\n")
cat("Number of samples:", ncol(counts_filtered), "\n")
cat("Number of genes analyzed:", nrow(res), "\n")
cat("Number of significant genes (padj < 0.05):", sig_genes, "\n")