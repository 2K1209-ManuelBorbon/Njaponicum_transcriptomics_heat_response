#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 50:00:00
#SBATCH -J Hifiasm_assembly
#SBATCH --mem=64G
#SBATCH --mail-type=END

# Variables for paths
RAW_DATA_DIR=/home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/data/raw_data/reads/genomics_chr3_data/chr3_clean_nanopore.fq.gz
WORK_DIR=/proj/uppmax2026-1-61/nobackup/work/Manu/assembled_genome/Hifiasm
PREFIX="nanopore_assembly"

# Work on UPPMAX and not in home directory
mkdir -p $WORK_DIR
cd $WORK_DIR

# Load module
module load hifiasm/0.25.0-GCCcore-13.3.0

# Run Hifiasm for Nanopore data
echo "Starting Hifiasm assembly"
echo "Input reads:" $RAW_DATA_DIR


hifiasm --ont -o $PREFIX $RAW_DATA_DIR


#  Convert GFA to FASTA (alternate haplotypes)
awk '/^S/{print ">"$2"\n"$3}' ${PREFIX}.bp.hap1.p_ctg.gfa > ${PREFIX}.hap1.fasta
awk '/^S/{print ">"$2"\n"$3}' ${PREFIX}.bp.hap2.p_ctg.gfa > ${PREFIX}.hap2.fasta

echo "Output files:"
ls -lh ${PREFIX}.*


# Calculate basic assembly statistics
echo -e "\nAssembly Statistics:"
echo "====================="
for fasta in ${PREFIX}.primary.fasta ${PREFIX}.hap1.fasta ${PREFIX}.hap2.fasta; do
    if [ -f "$fasta" ]; then
        echo "$fasta:"
        seqkit stats $fasta
        echo ""
    fi
done
