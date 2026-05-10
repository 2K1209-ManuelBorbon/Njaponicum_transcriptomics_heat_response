#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J FastQC_raw
#SBATCH --mail-type=END

# Paths to the files
reads=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/raw_data/reads/genomics_chr3_data
OUTDIR=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/01_preprocessing/fastqc_raw
mkdir -p "$OUTDIR"

# Load module
module load FastQC/0.12.1-Java-17

# Run FastaQC

for sample in ${reads}/*.gz
do
echo "Processing $sample"

# Run FastQC
fastqc $sample -o $OUTDIR
done
