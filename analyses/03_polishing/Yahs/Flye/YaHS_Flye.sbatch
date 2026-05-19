#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -J YaHS_Flye
#SBATCH -t 00:10:00
#SBATCH --mail-type=END


# Variables with absolute paths
ASSEMBLY=/proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Flye/pilon_polished.fasta
HiC_DATA=/proj/uppmax2026-1-61/nobackup/work/Manu/BWA/HiC/Flye/HiC_chr3_namesorted.bam

# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/YaHS/Flye
mkdir -p $WORK_DIR
cd $WORK_DIR

# Load module
module load YaHS/1.2.2-foss-2024a

# Run YaHS
echo "Starting YaHS assay"

# Run YaHS with the HiC data
yahs $ASSEMBLY $HiC_DATA

echo "YaHS assay done"
