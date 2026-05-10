#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J Indexing_Pilon
#SBATCH -t 00:10:00
#SBATCH --mail-type=END

# Variables for paths
ASSEMBLY=/proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Flye/pilon_polished.fasta

# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/YaHS/Flye/Indexing
mkdir -p $WORK_DIR
cd $WORK_DIR

# Load module
module load SAMtools/1.22.1-GCC-13.3.0

# Indexing Fasta
echo "Creating FASTA index for assembly..."
samtools faidx $ASSEMBLY
echo "Index created: ${ASSEMBLY}.fai"
