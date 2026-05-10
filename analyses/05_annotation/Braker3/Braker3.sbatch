#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH --mem=64G
#SBATCH -t 12:00:00
#SBATCH -J braker3_chr3

module load SAMtools/1.22-GCC-13.3.0

GENOME=/proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Flye/pilon_polished.fasta.masked
BAMDIR=/proj/uppmax2026-1-61/nobackup/work/Manu/HISAT2/ASSAY
OUTDIR=/proj/uppmax2026-1-61/nobackup/work/Manu/Braker3
BRAKER=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/raw_data/braker3.sif

mkdir -p $OUTDIR
export TMPDIR=$OUTDIR/tmp
mkdir -p $TMPDIR

BAMS=$(ls $BAMDIR/*.sorted.bam | tr '\n' ',' | sed 's/,$//')

echo "Using BAM files:"
echo $BAMS

singularity exec \
-B /home/mabo3966:/home/mabo3966 \
-B /home/mabo3966/bin/augustus_config:/opt/Augustus/config \
-B /proj/uppmax2026-1-61:/proj/uppmax2026-1-61 \
$BRAKER braker.pl \
    --genome=$GENOME \
    --bam=$BAMS \
    --softmasking \
    --species=mabo3966_chr3_moss \
    --threads=2 \
    --workingdir=$OUTDIR

echo "BRAKER3 finished"
