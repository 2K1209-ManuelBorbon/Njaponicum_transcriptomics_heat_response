#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH --reservation=uppmax2026-1-61_7
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH --mem=64G
#SBATCH -t 01:30:00
#SBATCH -J hisat2_chr3

# Load modules
module load HISAT2/2.2.1-gompi-2024a
module load SAMtools/1.22.1-GCC-13.3.0

# Path for variables

INDEX=/proj/uppmax2026-1-61/nobackup/work/Manu/HISAT2/INDEX/chr3_index
READS=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/raw_data/reads/transcriptomic_data
OUTDIR=/proj/uppmax2026-1-61/nobackup/work/Manu/HISAT2/ASSAY

mkdir -p $OUTDIR

SAMPLES=(
Control_1
Control_2
Control_3
Heat_treated_42_12h_1
Heat_treated_42_12h_2
Heat_treated_42_12h_3
)

for s in "${SAMPLES[@]}"; do
    echo "Sample being processed: $s"


    R1=$READS/${s}_f1.fq.gz
    R2=$READS/${s}_r2.fq.gz

    OUTBAM=$OUTDIR/${s}.sorted.bam

    hisat2 -p 2 -x $INDEX -1 $R1 -2 $R2 \
	| samtools sort -@ 2 -o $OUTBAM
    samtools index $OUTBAM
done
