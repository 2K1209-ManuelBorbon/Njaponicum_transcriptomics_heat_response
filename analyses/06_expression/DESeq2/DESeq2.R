library(DESeq2)

## Variable paths
count_data_path <- "/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/06_expression/FeatureCounts/Results/featurecounts_chr3.txt"

count_data <- read.table(fc_path,
  header = TRUE,
  sep = "\t",
  comment.char = "#",
  check.names = False)


col_data <- data.frame(
  condition = as.factor(gsub(
    "_[0-1]", "",
    colnames(count_data)
  )),
  row.names = colnames(count_data)
)


dds <- DESeqDataSetFromMatrix(
  countData = round(count_matrix),
  colData = col_data
  design = ~ condition
)

dds <- dds[rowSums(counts(dds)) > 10, ]

dds <- DESeq(dds)
res <- results(dds)
res <- res[order(res$padj), ]

out_dir <- /home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/06_expression/DESeq2/Result
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

write.csv(
  as.data.frame(res),
  file = file.path(out_dir, "deseq2_chr3_results.csv")
)

summary(res)

