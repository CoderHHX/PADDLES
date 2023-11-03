#!/bin/bash
#SBATCH --time=30:00:00
#SBATCH --mem=25gb
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
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
python Normal_training.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 1 --num_epochs 200 --T1 200 | tee "log/seed1_nor_cifar10_symmetric_rate_0.5.log"
python Normal_training.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 2 --num_epochs 200 --T1 200 | tee "log/seed2_nor_cifar10_symmetric_rate_0.5.log"
python Normal_training.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 3 --num_epochs 200 --T1 200 | tee "log/seed3_nor_cifar10_symmetric_rate_0.5.log"
python Normal_training.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 4 --num_epochs 200 --T1 200 | tee "log/seed4_nor_cifar10_symmetric_rate_0.5.log"
python Normal_training.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 5 --num_epochs 200 --T1 200 | tee "log/seed5_nor_cifar10_symmetric_rate_0.5.log"
#python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.1 | tee "pes_cifar10_instance_rate_0.4.log"

python Norm_AM.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 1 --num_epochs 200 --T1 200 | tee "log/seed1_AM_cifar10_symmetric_rate_0.5.log"
python Norm_AM.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 2 --num_epochs 200 --T1 200 | tee "log/seed2_AM_cifar10_symmetric_rate_0.5.log"
python Norm_AM.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 3 --num_epochs 200 --T1 200 | tee "log/seed3_AM_cifar10_symmetric_rate_0.5.log"
python Norm_AM.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 4 --num_epochs 200 --T1 200 | tee "log/seed4_AM_cifar10_symmetric_rate_0.5.log"
python Norm_AM.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 5 --num_epochs 200 --T1 200 | tee "log/seed5_AM_cifar10_symmetric_rate_0.5.log"
######################################################
python Norm_PH.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 1 --num_epochs 200 --T1 200 | tee "log/seed1_ph_cifar10_symmetric_rate_0.5.log"
python Norm_PH.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 2 --num_epochs 200 --T1 200 | tee "log/seed2_ph_cifar10_symmetric_rate_0.5.log"
python Norm_PH.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 3 --num_epochs 200 --T1 200 | tee "log/seed3_ph_cifar10_symmetric_rate_0.5.log"
python Norm_PH.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 4 --num_epochs 200 --T1 200 | tee "log/seed4_ph_cifar10_symmetric_rate_0.5.log"
python Norm_PH.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 5 --num_epochs 200 --T1 200 | tee "log/seed5_ph_cifar10_symmetric_rate_0.5.log"

python draw.py --Max_t 5 --noise_type symmetric --noise_rate 0.5
