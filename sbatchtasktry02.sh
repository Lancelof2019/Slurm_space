#!/bin/bash
#SBATCH --job-name=community_processing
#SBATCH --output=community_%A_%a.log
#SBATCH --error=community_%A_%a.err
#SBATCH --account=project_2010544
#SBATCH --partition=large
#SBATCH --array=1-${MAX_VALUE}
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=75G
srun python autoencoderMutex16.py
