######################################################################################################################################
library(DESeq2)

# Read DESeq2 results
dds <- readRDS("C:/Users/smart/Documents/Master_Bioinf/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/06_expression/DESeq2/Diagnostics/dds_object_chr3.rds")
# First extract the DESeq2 results as a data frame
res <- results(dds)  # This creates a DESeqResults object
res_df <- as.data.frame(res)  # Convert to regular data frame

# Add gene/transcript IDs as a column (from row names)
res_df$gene_id <- rownames(res_df)

# Read annotation file and extract header properly
raw <- read.delim(
  "eggnog_chr3.emapper.annotations",
  header = FALSE,
  sep = "\t",
  comment.char = "",
  quote = "",
  fill = TRUE,
  check.names = FALSE
)

# Find the row with the header
header_row <- which(raw$V1 == "#query")
if (length(header_row) > 0) {
  # Extract and clean the header
  header <- as.character(raw[header_row, ])
  header <- sub("^#", "", header)
  
  # Set column names
  colnames(raw) <- header
  
  # Remove comment rows (all rows before and including the header row)
  annotation <- raw[-(1:header_row), ]
  
  # Convert to appropriate data types
  annotation <- type.convert(annotation, as.is = TRUE)
} else {
  stop("Header line '#query' not found in the file")
}

# Check available columns
colnames(annotation)

# Select wanted columns
wanted_cols <- intersect(
  c("query", "Description", "GOs", "KEGG_ko", "PFAMs"),
  colnames(annotation)
)

# Merge DESeq2 results with annotation
merged <- merge(
  res_df,
  annotation[, wanted_cols, drop = FALSE],
  by.x = "gene_id",
  by.y = "query",
  all.x = TRUE
)

# Save results
write.csv(
  merged,
  "DESeq2_results_with_annotation_chr3.csv",
  row.names = FALSE
)

