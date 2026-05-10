#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 00:05:00
#SBATCH -J hisat2_indexing
#SBATCH --mail-type=END

# Load modules
module load HISAT2/2.2.1-gompi-2024a

# Variable paths
GENOME=/proj/uppmax2026-1-61/nobackup/work/Manu/RepeatMasker/Flye/pilon_polished.fasta.masked
OUTDIR=/proj/uppmax2026-1-61/nobackup/work/Manu/HISAT2/INDEX

mkdir -p $OUTDIR
cd $OUTDIR



hisat2-build -p 2 $GENOME chr3_index
