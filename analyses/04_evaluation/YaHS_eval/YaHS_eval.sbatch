#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J make_hic
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

mkdir -p /home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/04_evaluation/YaHS_eval
cd /home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/04_evaluation/YaHS_eval

# Variables
PILON=pilon_polished.fasta
PILON_FAI=pilon_polished.fasta.fai
YAHS=yahs.out.bin
YAHS_SCA=yahs.out_scaffolds_final.agp

# Load modules
module load YaHS/1.2.2-foss-2024a
module load SAMtools/1.22.1-GCC-13.3.0
module load Java/17

# Download the new Juicer Tools Jar directly from GitHub’s v3.0 release
wget -O juicer_tools.jar https://github.com/aidenlab/Juicebox/releases/download/v2.20.00/juicer_tools.2.20.00.jar
# Index your polished FASTA
samtools faidx $PILON

# Convert the Yahs .bin to a text format
juicer pre -a -o out_JBAT $YAHS $YAHS_SCA $PILON_FAI

# Math conversion
java -Xmx16G -jar /home/mabo3966/Genome_Analysis/Njaponicum_transcriptomics_heat_response/analyses/04_evaluation/YaHS_eval/juicer_tools.jar pre out_JBAT.txt out_JBAT.hic out_JBAT.chrom.sizes

