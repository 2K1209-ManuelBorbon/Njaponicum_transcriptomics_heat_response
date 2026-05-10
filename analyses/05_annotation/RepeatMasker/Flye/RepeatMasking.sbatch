#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH --mem=32G
#SBATCH -t 08:00:00
#SBATCH -J repeatmasking_chr3

# Load modules
module load RepeatMasker

# Variables
ASSEMBLY=/proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Flye/pilon_polished.fasta
OUTPUT_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/RepeatMasker/Flye

mkdir -p $OUTPUT_DIR

# Run the RepeatMasker module
RepeatMasker \
  -pa 2 \
  -species embryophyta \
  -xsmall \
  -dir $OUTPUT_DIR \
  $ASSEMBLY
