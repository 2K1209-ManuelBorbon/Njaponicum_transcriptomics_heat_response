#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J BWA_mapping_canu_assembly
#SBATCH --mail-type=END

# Variables for paths
FLYE_ASSEMLY=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/assembled_genome/flye/assembly.fasta
SHORT_READS=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/trimmed_data/
# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/BWA/flye
mkdir -p $WORK_DIR
cd $WORK_DIR

# Load module
module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22.1-GCC-13.3.0

# Run BWA
echo "Mapping started for Flye assembly with BWA"

bwa index $FLYE_ASSEMLY

# -M is used in case a read is mapped 2 times in the genome
# -R easier for samtools to distinguish between samples
bwa mem -t 2 -M -R "@RG\tID:chr3\tSM:sample\tLB:lib\tPL:ILLUMINA" \
    $FLYE_ASSEMLY \
    $SHORT_READS/chr3_illumina_R1_trimmed_paired.fastq.gz \
    $SHORT_READS/chr3_illumina_R2_trimmed_paired.fastq.gz \
    > chr3_aligned.sam
echo "Mapping with Illumina reads done!"
echo "Converting to BAM file,sorting and indexing..."
samtools view -Sb chr3_aligned.sam | samtools sort -o chr3_aligned.sorted.bam
samtools index chr3_aligned.sorted.bam
echo "Done!"
