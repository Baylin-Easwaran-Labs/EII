#!/bin/bash
# 
#       JOB_NAME: RLM_peread.sh
#
#       DATE: 12 Feb 2026
#
################################################
#Set options
################################################

#Set resource requirements
#SBATCH --time=24:00:00
#SBATCH --mail-type=end
#SBATCH --mail-user=sthursb3@jh.edu
#SBATCH --cpus-per-task=24
#SBATCH --job-name RLM
#SBATCH --mem=80G
#SBATCH --partition=parallel
#SBATCH -A heaswar1

ml bowtie2/2.4.1
ml samtools/1.10

mlStat=$?
echo mlStat : $mlStat
if [ $mlStat -eq 1 ]
then
  echo module load fail. Exiting
  exit 1
fi

module list

dataDir=$HOME/scr4_heaswar1/Sara/FromDesktop/EII/EIIAndColonCfDNA/mappedReads/
genomeDir=$HOME/data_heaswar1/Sara/genomes/hg19
outputDirName=perReadRlm
outputDataDir=$HOME/scr4_heaswar1/Sara/FromDesktop/EII/EIIAndColonCfDNA/
BamData=$HOME/scr4_heaswar1/Sara/FromDesktop/EII/EIIAndColonCfDNA/mappedReads/

date
echo "Running ${SLURM_JOBID}"
hostname

echo "dataDir: $dataDir"
echo "genomeDir: $genomeDir"
echo "outputDirName: $outputDirName"
echo "outputDataDir: $outputDataDir"
echo "BamData: $BamData"


cd $BamData

echo "pwd: $(pwd)"

inputbams=(*.deduplicated.bam)

echo "inputbams: ${BamData}${inputbams[$SLURM_ARRAY_TASK_ID]}"

cd $HOME/scr4_heaswar1/Austin/EII/command_line/build/

echo "pwd:$(pwd)"

bin/RLM -r ${genomeDir}/hg19.fa -b ${BamData}${inputbams[$SLURM_ARRAY_TASK_ID]} -m PE -s single_read -a bismark -o ${BamData}${inputbams[$SLURM_ARRAY_TASK_ID]}.perReadMethylation_RLM.txt

# -r reference genome, -b bam input, -m mode (SE, PE), -s score to compute (single_read, entropy, pdr or all), -a aligner  [bsmap,bismark,segemehl,gem], -o output

echo "-----------------------"
echo "---------DONE----------"
echo "-----------------------"

date

