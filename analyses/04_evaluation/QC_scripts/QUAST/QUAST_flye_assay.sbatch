#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:10:00
#SBATCH -J QUAST_flye_polished
#SBATCH --mail-type=END

# Load necessary modules
module load QUAST/5.2.0

# Necessary variables
WORKDIR=/proj/uppmax2026-1-61/nobackup/work/Manu/Polished_QC/QUAST/Flye
PILON_OUT=/proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Flye/pilon_polished.fasta
FLYE_GENOME=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/assembled_genome/flye/assembly.fasta

mkdir -p $WORKDIR
cd $WORKDIR

# Running BUSCO
module load BUSCO/5.8.2-gfbf-2024a

quast.py \
  -o $WORKDIR \
  -t 2 \
  -l CANU,PILON \
  $FLYE_GENOME \
  $PILON_OUT
