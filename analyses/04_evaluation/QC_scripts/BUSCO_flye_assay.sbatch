#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J BUSCO_flye_prepolish
#SBATCH --mail-type=END

# Load necessary modules
module load BUSCO/5.8.2-gfbf-2024a

# Necessary variables
WORKDIR=/proj/uppmax2026-1-61/nobackup/work/Manu/Polished_QC/Flye
FLYE_ASSEMBLY=/proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Flye/pilon_polished.fasta

mkdir -p $WORKDIR
cd $WORKDIR

# Running BUSCO
module load BUSCO/5.8.2-gfbf-2024a

busco \
  -i $FLYE_ASSEMBLY \
  -l embryophyta_odb10 \
  -o flye_busco_chr3\
  -m genome \
  -c 2
