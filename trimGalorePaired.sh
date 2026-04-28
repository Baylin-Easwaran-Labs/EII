#!/bin/sh

#  fastqc-paired.sh
#
#
#  Feb 9th 2026

################################################
#Set options
################################################
#Set resource requirements
#SBATCH --time=24:00:00
#SBATCH --mail-type=end 
#SBATCH --mail-user=sthursb3@jhu.edu 
#SBATCH --ntasks=24
#SBATCH --job-name fastqc-paired
#SBATCH --mem=64G 
#SBATCH --partition=parallel 
#SBATCH --account heaswar1


# Start script
#module load python/3.8.6
#module load fastqc/0.11.9
#module load trim_galore
module load anaconda3


mlStat=$?
echo mlStat : $mlStat
if [ $mlStat -eq 1 ]
then
  echo module load fail. Exiting
  exit 1
fi

module list

date
echo "running ${SLURM_JOBID} job now"
hostname

#----------------------------------
#Inputs
#----------------------------------
baseDir=/home/sthursb3/scr4_heaswar1/Sara/FromDesktop/EII/EIIAndBreastCfDNA

rawData=${baseDir}/rawData

fastqcReportDir=fastqcReports

trimmedReportDir=trimmedFastqcP

fileExt=fastq.gz


#----------------------------------

echo "Inputs used listed below"

echo "baseDir: ${baseDir}"

echo "rawData: ${rawData}"

echo "fastqcReportDir: ${fastqcReportDir}"

echo "trimmedReportDir: ${trimmedReportDir}"

echo "fileExt: ${fileExt}"

cd $rawData

echo "pwd: $(pwd)"

mates1=(*_1.${fileExt})
mates2=(*_2.${fileExt})



echo "---------------------------"
echo "---------SAMPLES-----------"
echo "---------------------------"

echo "mates1: ${mates1[*]}"
echo "mates2: ${mates2[*]}"
echo
echo "running Fastqc on ${SLURM_JOBID}"
echo
echo "pwd: $(pwd)"
echo
mkdir ${baseDir}/${fastqcReportDir}

mkdir ${baseDir}/${fastqcReportDir}/${untrimmedReportDir}

echo "fastqc reports dir: ${baseDir}/${fastqcReportDir}"
echo "untrimmed fastqc reports dir: ${baseDir}/${fastqcReportDir}/${untrimmedReportDir}"

conda activate fastqc-ChIP #contains fastqc and trim_galore

echo "--------------------------------"
echo "---------FASTQC-----------------"
echo "--------------------------------"

fastqc -o ${baseDir}/${fastqcReportDir}/${untrimmedReportDir}  -t 24 ${mates1[$SLURM_ARRAY_TASK_ID]}

fastqc -o ${baseDir}/${fastqcReportDir}/${untrimmedReportDir}  -t 24 ${mates2[$SLURM_ARRAY_TASK_ID]}       #*.${filetype}

echo "command run = fastqc -o ${baseDir}/${fastqcReportDir}/${untrimmedReportDir} -t 24 ${mates1[$SLURM_ARRAY_TASK_ID]}"

echo "command run = fastqc -o ${baseDir}/${fastqcReportDir}/${untrimmedReportDir} -t 24 ${mates2[$SLURM_ARRAY_TASK_ID]}"

conda deactivate

echo "--------------------------------"
echo "--------multiqc-----------------"
echo "--------------------------------"

cd ${baseDir}/${fastqcReportDir}/${untrimmedReportDir}
echo
echo "pwd: $(pwd)"
echo

conda activate multiqc

multiqc -f .

echo " command run: multiqc -f ."

conda deactivate

echo
echo "running Trim Galore on ${SLURM_JOBID}"
echo
echo "pwd: $(pwd)"



conda activate fastqc-ChIP #contains fastqc and trim_galore


echo "-------------------------------"
echo "-------Trim Galore!------------"
echo "-------------------------------"

cd ${rawData}

echo "pwd: $(pwd)"

mkdir ${baseDir}/${fastqcReportDir}/${trimmedReportDir}

echo "trimmed FastqcDir: ${baseDir}/${fastqcReportDir}/${trimmedReportDir}"

mkdir ${baseDir}/trimmedDataP

echo "trimmed data dir: ${baseDir}/trimmedDataP"

trim_galore  --fastqc_args "--outdir ${baseDir}/${fastqcReportDir}/${trimmedReportDir}" -o ${baseDir}/trimmedDataP  --paired ${mates1[$SLURM_ARRAY_TASK_ID]} ${mates2[$SLURM_ARRAY_TASK_ID]}  #*.${filetype}

#echo "trim_galore --fastqc_args --outdir ${baseDir}/${fastqcReportDir}/${trimmedReportDir} -o ${baseDir}/trimmedDataP ${samples[$SLURM_ARRAY_TASK_ID]}"

echo "trim_galore  --fastqc_args "--outdir ${baseDir}/${fastqcReportDir}/${trimmedReportDir}" -o ${baseDir}/trimmedDataP  --paired ${mates1[$SLURM_ARRAY_TASK_ID]} ${mates2[$SLURM_ARRAY_TASK_ID]}"

conda deactivate

echo "-------------------------------"
echo "-------multiqc on trimmed------"
echo "-------------------------------"

cd ${baseDir}/${fastqcReportDir}/${trimmedReportDir}

echo "pwd: $(pwd)"

conda activate multiqc

multiqc -f .

echo "command run: multiqc -f ."

conda deactivate

echo "-----------------------"
echo "---------DONE----------"
echo "-----------------------"

date







