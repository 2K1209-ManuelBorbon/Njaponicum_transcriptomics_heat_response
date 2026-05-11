#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J deseq2_chr3
#SBATCH --mail-type=END

# Load modules
module load R/4.4.2-gfbf-2024a

export R_LIBS_USER=/gorilla/home/mabo3966/R/x86_64-pc-linux-gnu-library/4.4

mkdir -p $R_LIBS_USER

# R script
Rscript /home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/06_expression/DESeq2/DESeq2.sbatch
