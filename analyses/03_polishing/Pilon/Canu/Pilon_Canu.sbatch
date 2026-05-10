#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 25:00:00
#SBATCH -J Pilon_essay
#SBATCH --mail-type=END

# Variables for paths
CANU_ASSEMBLY=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/assembled_genome/canu/chromosome3_canu.contigs.fasta
BWA_file=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/03_polishing/BWA/Canu
# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Canu
mkdir -p $WORK_DIR
cd $WORK_DIR

# Load module
module load Pilon/1.24-Java-17

# Run Pilon
echo "Starting Polishing of the Canu assembly with Pilon"
pilon \
    --genome $CANU_ASSEMBLY \
    --frags $BWA_file/chr3_aligned.sorted.bam \
    --output pilon_polished \
    --outdir $WORK_DIR \
    --threads 2 \
    --fix all
echo "Done!"
