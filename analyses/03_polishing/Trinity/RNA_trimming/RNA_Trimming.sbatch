#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J RNA_Trimming
#SBATCH --mail-type=END

# Variables for paths
RAW_DATA_DIR=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/raw_data/reads/transcriptomic_data
TRIMMOMATIC=/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa

# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/trimmed_data/Transcriptomic
mkdir -p $WORK_DIR
cd $WORDK_DIR

# Load module
module load Trimmomatic/0.39-Java-17

# Run Trimmomatic
echo "Procesing transcriptomic reads"

# Process each pair of files (R1 and R2)
for R1_file in ${RAW_DATA_DIR}/*_1_f1.fq.gz; do
    # Get the base sample name (without _1_f1.fq.gz suffix)
    base=$(basename $R1_file _1_f1.fq.gz)

    # Define the corresponding R2 file
    R2_file="${RAW_DATA_DIR}/${base}_2_r2.fq.gz"

    # Check if R2 file exists
    if [ -f "$R2_file" ]; then
        echo "Processing sample: $base"

        trimmomatic PE \
            $R1_file \
            $R2_file \
            ${WORK_DIR}/${base}_R1_trimmed_paired.fastq.gz \
            ${WORK_DIR}/${base}_R1_trimmed_unpaired.fastq.gz \
            ${WORK_DIR}/${base}_R2_trimmed_paired.fastq.gz \
            ${WORK_DIR}/${base}_R2_trimmed_unpaired.fastq.gz \
            ILLUMINACLIP:$TRIMMOMATIC:2:30:10:2:True \
            LEADING:3 TRAILING:3 \
            SLIDINGWINDOW:4:15 MINLEN:36
    else
        echo "Warning: Could not find R2 file for $base"
    fi
done

echo "Transcriptomic trimming complete"

# Create symbolic links in the trimmed_data directory
cd /home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/trimmed_data
mkdir -p Transcriptomic
cd Transcriptomic

echo "Creating symbolic links for all trimmed files"
for trimmed_file in ${WORK_DIR}/*.fastq.gz; do
    ln -s $trimmed_file .
done

echo "All symbolic links created"
