#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J FastQC_trim
#SBATCH --mail-type=END

# Paths to the files
reads=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/trimmed_data
OUTDIR=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/01_preprocessing/fastqc_trim
mkdir -p "$OUTDIR"

# Load module
module load FastQC/0.12.1-Java-17

# Run FastaQC

for sample in ${reads}/*.fastq.gz
do
echo "Processing $sample"

# Run FastQC
fastqc $sample -o $OUTDIR
done

