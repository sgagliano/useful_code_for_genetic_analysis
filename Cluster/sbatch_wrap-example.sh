#!/bin/bash

#for CHR in `seq 1 22`
for chr in {1..22} X
do
        sbatch --mem=8000 --job-name=test${CHR} --time=100:00:00 --wrap="<my_command>" -o slurm_output_${CHR}.log 
done
