#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 1
#SBATCH -t 50:00:00
#SBATCH -J flye_assembly
#SBATCH --mem=64G
#SBATCH --mail-type=END

# Variables for paths
RAW_DATA_DIR=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/raw_data/reads/genomics_chr3_data/chr3_clean_nanopore.fq.gz

# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/assembled_genome/flye
mkdir -p $WORK_DIR
cd $WORDK_DIR

# Load module
module load Flye/2.9.6-GCC-13.3.0

# Run Canu
echo "Starting Flye assembly!"
flye --nano-raw $RAW_DATA_DIR -g 16m -o $WORK_DIR

echo "Flye assembly complete!"

ln -s $WORK_DIR/assembly.fasta .
ln -s $WORK_DIR/assembly_info.txt .

