#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J featurecount_chr3
#SBATCH --mail-type=END

# Load modules
module load Subread/2.1.1-GCC-13.3.0

# Variables
SORTED_BAMS=/proj/uppmax2026-1-61/nobackup/work/Manu/HISAT2/ASSAY
GTF=/proj/uppmax2026-1-61/nobackup/work/Manu/Braker3/braker.gtf
OUTDIR=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/06_expression/FeatureCounts/Results

mkdir -p $OUTDIR

# Run feature Counts
featureCounts \
    -T 2 \
    -p \
    -t exon \
    -g gene_id \
    -a $GTF \
    -o $OUTDIR/featurecounts_chr3.txt \
    $SORTED_BAMS/*sorted.bam
