#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 25:00:00
#SBATCH -J Pilon_essay_flye
#SBATCH --mail-type=END

# Variables for paths
FLYE_ASSEMBLY=/proj/uppmax2026-1-61/nobackup/work/Manu/assembled_genome/flye/assembly.fasta
BWA_file=/proj/uppmax2026-1-61/nobackup/work/Manu/BWA/flye
# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Flye
mkdir -p $WORK_DIR
cd $WORK_DIR

# Load module
module load Pilon/1.24-Java-17

# Run Pilon
echo "Starting Polishing of the Flye assembly with Pilon"
pilon \
    --genome $FLYE_ASSEMBLY \
    --frags $BWA_file/chr3_aligned.sorted.bam \
    --output pilon_polished \
    --outdir $WORK_DIR \
    --threads 2 \
    --fix all
echo "Done!"
