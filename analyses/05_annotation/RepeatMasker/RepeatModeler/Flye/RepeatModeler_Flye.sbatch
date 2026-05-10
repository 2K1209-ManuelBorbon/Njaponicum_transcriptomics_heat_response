#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH --mail-type=END

# Load modules
module load RepeatModeler/2.0.7-foss-2024a

#Move to Working directory
cd /proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Flye

#Build database
BuildDatabase -name -n_japonicum \
/proj/uppmax2026-1-61/nobackup/work/Manu/Pilon/Flye/pilon_polished.fasta

RepeatModeler -database -n_japonicum \
-LTRStruct > out.log
