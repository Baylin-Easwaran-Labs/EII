#!/bin/bash

#	fastq_gzip.sh
#
#
#	Feb 5th 2026
################################################
#Set options
################################################
#Set resource requirements
#SBATCH --time=01-00:00:00
#SBATCH --mail-type=end
#SBATCH --mail-user=sthursb3@jhu.edu
#SBATCH --job-name fastq_gzip
#SBATCH --partition=parallel
#SBATCH --mem=8G
#SBATCH --ntasks=6
#SBATCH --account heaswar1



date
echo "running ${SLURM_JOBID} job now"
hostname


cd /home/sthursb3/scr4_heaswar1/Sara/FromDesktop/EII/EIIAndBreastCfDNA/rawData
echo "pwd: $(pwd)"



fastq1=(*_1.fastq)
fastq2=(*_2.fastq)

echo "fastq1: ${fastq1[*]}"

echo "fastq2: ${fastq2[*]}"

for i in "${fastq1[@]}"
do
	echo "i: $i"
	gzip $i
done

for j in "${fastq2[@]}"
do
	echo "j: $j"
	gzip $j
done

echo "finished ${SLURM_JOBID}"

echo "-------done-------"

