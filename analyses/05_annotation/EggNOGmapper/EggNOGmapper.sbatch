#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH --mem=64G
#SBATCH -t 18:00:00
#SBATCH -J eggnog_chr3
#SBATCH  --mail-type=END

# Load modules
module load eggnog-mapper/2.1.13-gfbf-2024a

# Variables
PROTEINS=/proj/uppmax2026-1-61/nobackup/work/Manu/Braker3/braker.aa
OUTDIR=/proj/uppmax2026-1-61/nobackup/work/Manu/EggNOGmapper

mkdir -p $OUTDIR

cd $OUTDIR

echo "Running eggNOG-mapper on:"
echo $PROTEINS

emapper.py \
    -i $PROTEINS \
    -o eggnog_chr3 \
    --output_dir $OUTDIR \
    --cpu 2 \
    --itype proteins \
    --go_evidence all \
    --pfam_realign realign \
    --data_dir /sw/data/eggNOG/5.0.0/rackham/ \
    --override

echo "eggNOG-mapper finished"
