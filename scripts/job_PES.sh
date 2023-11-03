#!/bin/bash
#SBATCH --time=08:00:00
#SBATCH --mem=100gb
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
 
--------------------------------------------------------------------------------
# Preparation
# You could drop some commands to setup the environment before running the code.
# E.g., activate the environment configuration files
--------------------------------------------------------------------------------
#source /path/conda.sh  # Your conda installation
#conda activate my-env-file  # Activate the environment to run the code
 
--------------------------------------------------------------------------------
# Running codes with a few arguments
--------------------------------------------------------------------------------
#python myscript.py \
#--class_uniform_tile 375 \
#--result_dir ${_SAVEDIR}
module load pytorch
module load torchvision
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 1 | tee "seed1_pes_cifar10_symmetric_rate_0.5.log"
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 2 | tee "seed2_pes_cifar10_symmetric_rate_0.5.log"
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 3 | tee "seed3_pes_cifar10_symmetric_rate_0.5.log"
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 4 | tee "seed4_pes_cifar10_symmetric_rate_0.5.log"
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 5 | tee "seed5_pes_cifar10_symmetric_rate_0.5.log"
#python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.1 | tee "pes_cifar10_instance_rate_0.4.log"