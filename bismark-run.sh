#!/bin/sh

#  bismark-run.sh
#
#
#  Feb 11th 2026

################################################
#Set options
################################################
#Set resource requirements
#SBATCH --time=24:00:00
#SBATCH --mail-type=end
#SBATCH --mail-user=sthursb3@jhu.edu
#SBATCH --cpus-per-task=6
#SBATCH --job-name bismark-run
#SBATCH --mem=0
#SBATCH --partition=parallel
#SBATCH -A heaswar1



###################
######Inputs#######
###################

dataDir=/home/sthursb3/scr4_heaswar1/Sara/FromDesktop/EII/EIIAndBreastCfDNA/trimmedDataP

genomeDir=$HOME/data_heaswar1/Sara/genomes/hg19

outputDirName=mappedReads

outputDataDir=/home/sthursb3/scr4_heaswar1/Sara/FromDesktop/EII/EIIAndBreastCfDNA

fileExt=fq.gz

##################

# Start script
module load anaconda3

mlStat=$?
echo mlStat : $mlStat
if [ $mlStat -eq 1 ]
then
  echo module load fail. Exiting
  exit 1
fi

module list

conda activate bismark

date
echo "running ${SLURM_JOBID} job now"
hostname

echo "Inputs are listed below"
echo "dataDir: $dataDir"
echo "genomeDir: $genomeDir"
echo "outputDirName: $outputDirName"
echo "outputDataDir: $outputDataDir"
echo "fileExt: $fileExt"


cd $dataDir

echo "pwd: $(pwd)"

mates1=(*_1_val_1.${fileExt})
mates2=(*_2_val_2.${fileExt})
echo "mates1: ${mates1[*]}"
echo "mates2: ${mates2[*]}"



mkdir ${outputDataDir}/${outputDirName}

outputDir=${outputDataDir}/${outputDirName}


echo "------------------"
echo "-----Bismark------"
echo "------------------"

echo "mates1: ${mates1[$SLURM_ARRAY_TASK_ID]}"
echo "mates2: ${mates2[$SLURM_ARRAY_TASK_ID]}"


#--parallel 4 --un (report unmapped)  -o (outputDir)

bismark --parallel 4 --un -o $outputDir  --genome $genomeDir -1 ${mates1[$SLURM_ARRAY_TASK_ID]} -2 ${mates2[$SLURM_ARRAY_TASK_ID]}

#bismark --parallel 4 --un -o $outputDir  --genome $genomeDir -1 *_1.fastq.gz -2 *_2.fastq.gz


echo "Bismark Ended, Deduplication start"

cd $outputDir

echo "pwd:$(pwd)"

bam_files=(*_1_bismark_bt2_pe.bam)

echo "Deduplicate target: ${bam_files[$SLURM_ARRAY_TASK_ID]}"

deduplicate_bismark --bam -p  ${bam_files[$SLURM_ARRAY_TASK_ID]} #only thing we need to specify is the input data type and -p for paired end

echo "Deduplicate End!"


conda deactivate

echo "-----------------------"
echo "---------DONE----------"
echo "-----------------------"

date
