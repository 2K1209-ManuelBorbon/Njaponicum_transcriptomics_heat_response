#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J BUSCO_canu_prepolish
#SBATCH --mail-type=END

# Load necessary modules
module load BUSCO/5.8.2-gfbf-2024a

# Necessary variables
WORKDIR=/proj/uppmax2026-1-61/nobackup/work/Manu/assembled_genome/QC/Canu
CANU_GENOME=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/assembled_genome/canu/chromosome3_canu.contigs.fasta

mkdir -p $WORKDIR
cd $WORKDIR

# Running BUSCO
module load BUSCO/5.8.2-gfbf-2024a

busco \
  -i $CANU_GENOME \
  -l embryophyta_odb10 \
  -o canu_busco_chr3\
  -m genome \
  -c 2
