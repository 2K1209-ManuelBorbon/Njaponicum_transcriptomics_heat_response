#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 31:00:00
#SBATCH -J canu_assembly
#SBATCH --mail-type=END

# Variables for paths
RAW_DATA_DIR=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/raw_data/reads/genomics_chr3_data/chr3_clean_nanopore.fq.gz

# Work on UPPMAX and not in home directory
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/assembled_genome/canu
mkdir -p $WORK_DIR
cd $WORDK_DIR

# Load module
module load canu/2.3-GCCcore-13.3.0-Java-17
module load SAMtools/1.22.1-GCC-13.3.0

# Run Canu
echo "Startiing Canu assembly"
canu -p chromosome3_canu \
-d $WORK_DIR \
genomeSize=16m \
-nanopore $RAW_DATA_DIR \
gridOptions="-A uppmax2026-1-61 -M pelle -t 12:00:00" \
maxThreads=2 \
corThreads=2 \
oeaThreads=2 \
cnsThreads=2 \

echo "Canu assembly complete"
