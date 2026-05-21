# ============================================================================
# GO ENRICHMENT AND RRVGO ANALYSIS FOR N. JAPONICUM
# ============================================================================

# Load required libraries
library(DESeq2)
library(clusterProfiler)
library(rrvgo)
library(tidyverse)
library(AnnotationDbi)
library(GO.db)

# For non-model organisms - Install if needed
library(gprofiler2)

# ============================================================================
# Load DESeq2 results with annotation
# ============================================================================

# Read your merged DESeq2 results
deseq2_results <- read.csv("C:/Users/smart/Documents/Master_Bioinf/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/06_expression/DESeq2/DESeq2_results_with_annotation_chr3.csv")

# Check the structure
str(deseq2_results)
head(colnames(deseq2_results))

# View first few rows
head(deseq2_results[, 1:10])

# Identify the gene ID column (first column usually)
gene_id_column <- colnames(deseq2_results)[1]
cat("\nGene ID column:", gene_id_column, "\n")

# ============================================================================
# Filter significant genes
# ============================================================================

# Define significance criteria
sig_genes <- deseq2_results %>%
  filter(!is.na(padj)) %>%           # Remove NA p-values
  filter(padj < 0.05) %>%            # Adjusted p-value < 0.05
  filter(abs(log2FoldChange) > 1)    # |log2FC| > 1 

# Extract gene IDs using the identified column name
all_sig_genes <- sig_genes[[gene_id_column]]

# Separate up and down regulated genes
up_genes <- sig_genes %>%
  filter(log2FoldChange > 0) %>%
  pull(!!sym(gene_id_column))

down_genes <- sig_genes %>%
  filter(log2FoldChange < 0) %>%
  pull(!!sym(gene_id_column))

# REMOVED duplicate assignment - this line was causing the issue:
# all_sig_genes <- sig_genes$Row.names  # <-- DELETE THIS LINE

# Print summary
cat("\nSummary of significant genes:\n")
cat("Total significant genes:", length(all_sig_genes), "\n")
cat("Up-regulated genes:", length(up_genes), "\n")
cat("Down-regulated genes:", length(down_genes), "\n")
cat("\nFirst few gene IDs:\n")
print(head(all_sig_genes))

# ============================================================================
# STEP 3: GO Enrichment with g:Profiler
# ============================================================================

organism_options <- c(
  "hsapiens",  # Human (for testing)
  "mmusculus",                # Mouse (for testing)
)

gost_results <- NULL

for(org in organism_options) {
  cat("\nTrying organism:", org, "...\n")
  
  if(org == "auto") {
    # Auto-detect organism
    gost_results <- tryCatch({
      gost(
        query = all_sig_genes,
        sources = "GO",
        significant = TRUE,
        user_threshold = 0.05
      )
    }, error = function(e) {
      cat("Error:", e$message, "\n")
      return(NULL)
    })
  } else {
    # Specific organism
    gost_results <- tryCatch({
      gost(
        query = all_sig_genes,
        organism = org,
        sources = "GO",
        significant = TRUE,
        user_threshold = 0.05
      )
    }, error = function(e) {
      cat("Error:", e$message, "\n")
      return(NULL)
    })
  }
  
  if(!is.null(gost_results) && !is.null(gost_results$result) && nrow(gost_results$result) > 0) {
    cat("✓ Success with organism:", ifelse(org == "auto", "auto-detected", org), "\n")
    break
  }
}

# Check if we even got results
if(!is.null(gost_results) && !is.null(gost_results$result) && nrow(gost_results$result) > 0) {
  go_enrichment <- gost_results$result
  
  cat("\nFound", nrow(go_enrichment), "significant GO terms\n")
  
  # Format for rrvgo
  go_for_rrvgo <- data.frame(
    go_id = go_enrichment$term_id,
    p_value = go_enrichment$p_value,
    description = go_enrichment$term_name,
    ontology = go_enrichment$source,
    stringsAsFactors = FALSE
  )
  
  # Remove duplicates
  go_for_rrvgo <- go_for_rrvgo %>%
    group_by(go_id) %>%
    summarise(
      p_value = min(p_value),
      description = first(description),
      ontology = first(ontology)
    ) %>%
    ungroup()
  
  # Save GO results
  write.csv(go_for_rrvgo, "GO_enrichment_results.csv", row.names = FALSE)
  cat("\nSaved GO enrichment results to GO_enrichment_results.csv\n")
}