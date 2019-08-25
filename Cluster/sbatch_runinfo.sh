#!/bin/bash
#SBATCH --error=score.err
#SBATCH --output=score.out
#SBATCH --job-name=score
#SBATCH --time=24:00:00
#SBATCH --mem=24G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-1
declare -a commands
commands[1]="/usr/bin/time -o score.runinfo.txt -v <insert script here>"
bash -c "${commands[${SLURM_ARRAY_TASK_ID}]}"
