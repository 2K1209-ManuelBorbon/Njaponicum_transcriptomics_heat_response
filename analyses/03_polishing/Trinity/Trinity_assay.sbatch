#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 00:10:00
#SBATCH -J Trinity_assay
#SBATCH --mail-type=END

# Variables for paths
DATA_DIR=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/trimmed_data/Transcriptomic

# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/Trinity
mkdir -p $WORK_DIR
cd $DATA_DIR

# Load module
module load Trinity/2.15.2-foss-2024a-Java-17

# Run Trimmomatic
echo "Starting Trinity assay"

# Run Trinity with Control and Heat Treatment
Trinity --seqType fq \
--max_memory 16G \
--left $DATA_DIR/Control_R1_trimmed_paired.fastq.gz, $DATA_DIR/Heat_treated_42_12h_R1_trimmed_paired.fastq.gz \
--right $DATA_DIR/Control_R2_trimmed_paired.fastq.gz,$DATA_DIR/Heat_treated_42_12h_R2_trimmed_paired.fastq.gz \
--output $WORK_DIR/trinity_assembly \
--full_cleanup

echo "Trinity assembly completed"
