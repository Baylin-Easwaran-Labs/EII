#!/bin/bash

#	SRA_fasterq_dump.sh
#
#
#	Feb 5th 2026
################################################
#Set options
################################################
#Set resource requirements
#SBATCH --time=03-00:00:00
#SBATCH --mail-type=end
#SBATCH --mail-user=sthursb3@jhu.edu
#SBATCH --job-name fasterq_dump
#SBATCH --partition=parallel
#SBATCH --mem=80G
#SBATCH --ntasks=24
#SBATCH --account heaswar1

ml sra-tools/3.0.0

date
echo "running ${SLURM_JOBID} ${SLURM_ARRAY_TASK_ID} job now"
hostname


echo "--------------"
echo "----Inputs----"
echo "--------------"

dataDir=/home/sthursb3/scr4_heaswar1/Sara/sra_data/breast_cfDNA/srafiles

baseDir=/home/sthursb3/scr4_heaswar1/Sara/FromDesktop/EII/EIIAndBreastCfDNA

echo "dataDir: ${dataDir}"
echo
echo "baseDir: ${baseDir}"

#end of Inputs
#---------------------------------------------------------------------------------------------

#file_name=$1 #i.e. GSE274387
cd $dataDir

echo "pwd: $(pwd)"

files=(*/*.sra)

echo "---------------------------"
echo "---------SAMPLES-----------"
echo "---------------------------"

echo "samples: ${files[*]}"

cd $baseDir

echo "pwd: $(pwd)"

echo "Current file: ${files[$SLURM_ARRAY_TASK_ID]}"

acc=$(echo ${files[$SLURM_ARRAY_TASK_ID]} | cut -f 2 -d '/'| cut -f 1 -d '.')

echo "acc: ${acc}"

mkdir rawData

cd rawData

echo "pwd: $(pwd)"

fasterq-dump  $acc #-0 = outputdir

#fasterq-dump -O /home/austinjin/scratch4-heaswar1/Austin/EII/fastq_data/${file_name} SRR5146993


echo "fastq1: ${acc}_1.fastq"

echo "fastq2: ${acc}_2.fastq"

gzip ${acc}_1.fastq ${acc}_2.fastq

echo "finished ${SLURM_ARRAY_TASK_ID}"

echo "-------done-------"

