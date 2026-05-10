#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J Trimming_Illumina
#SBATCH --mail-type=END

# Variables for paths
RAW_DATA_DIR=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/raw_data/reads/genomics_chr3_data
TRIMMOMATIC=/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa

# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/trimmed_data
mkdir -p $WORK_DIR
cd $WORDK_DIR

# Load module
module load Trimmomatic/0.39-Java-17

# Run Trimmomatic
echo "Procesing Illumina reads"
trimmomatic PE \
	$RAW_DATA_DIR/chr3_illumina_R1.fastq.gz \
	$RAW_DATA_DIR/chr3_illumina_R2.fastq.gz \
	$WORK_DIR/chr3_illumina_R1_trimmed_paired.fastq.gz \
	$WORK_DIR/chr3_illumina_R1_trimmed_unpaired.fastq.gz \
	$WORK_DIR/chr3_illumina_R2_trimmed_paired.fastq.gz \
	$WORK_DIR/chr3_illumina_R2_trimmed_unpaired.fastq.gz \
	ILLUMINACLIP:$TRIMMOMATIC:2:30:10:2:True \
	LEADING:3 TRAILING:3 \
	SLIDINGWINDOW:4:15 MINLEN:36

echo "Illumina trimming complete"

cd /home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data
mkdir trimmed_data
cd trimmed_data

ln -s $WORK_DIR/chr3_illumina_R1_trimmed_paired.fastq.gz .
ln -s $WORK_DIR/chr3_illumina_R1_trimmed_unpaired.fastq.gz .
ln -s $WORK_DIR/chr3_illumina_R2_trimmed_paired.fastq.gz .
ln -s $WORK_DIR/chr3_illumina_R2_trimmed_unpaired.fastq.gz .
