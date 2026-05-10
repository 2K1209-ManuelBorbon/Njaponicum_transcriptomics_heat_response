#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J BWA_HiC_data
#SBATCH --mail-type=END

# Variables for paths
CANU_ASSEMBLY=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/assembled_genome/canu/chromosome3_canu.contigs.fasta
HiC=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/raw_data/reads/genomics_chr3_data
# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/BWA/HiC/Canu
mkdir -p $WORK_DIR
cd $WORK_DIR

# Load module
module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22.1-GCC-13.3.0

# Index the assembly
echo "Indexing assembly with BWA..."
bwa index $CANU_ASSEMBLY

# Map Hi-C reads with BWA MEM (using -5SP flag for better Hi-C alignment)
echo "Mapping Hi-C reads..."
bwa mem -5SP -M \
    -R "@RG\tID:chr3\tSM:sample\tLB:lib\tPL:ILLUMINA" \
    $CANU_ASSEMBLY \
    $HiC/chr3_hiC_R1.fastq.gz \
    $HiC/chr3_hiC_R2.fastq.gz \
    > HiC_chr3_aligned.sam

echo "Mapping completed!"

# Convert SAM to BAM and filter out unmapped, secondary, supplementary
# -F 0x904 = 2308 = unmapped (0x4) + secondary (0x100) + supplementary (0x800)
echo "Converting to BAM and filtering..."
samtools view -b -F 0x904 -q 10 HiC_chr3_aligned.sam > HiC_chr3_filtered.bam

# Sort by READ NAME (important for YaHS to use middle positions)
echo "Sorting by read name (for YaHS)..."
samtools sort -n -o HiC_chr3_namesorted.bam HiC_chr3_filtered.bam

# Index (optional but useful)
samtools index HiC_chr3_namesorted.bam

# Clean up
rm HiC_chr3_aligned.sam HiC_chr3_filtered.bam
