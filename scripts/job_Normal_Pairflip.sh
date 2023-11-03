#!/bin/bash
#SBATCH --time=30:00:00
#SBATCH --mem=25gb
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
 
#--------------------------------------------------------------------------------
# Preparation
# You could drop some commands to setup the environment before running the code.
# E.g., activate the environment configuration files
#--------------------------------------------------------------------------------
#source /path/conda.sh  # Your conda installation
#conda activate my-env-file  # Activate the environment to run the code
 
#--------------------------------------------------------------------------------
# Running codes with a few arguments
#--------------------------------------------------------------------------------
module load pytorch
module load torchvision
#############################################################################################
python Normal_training.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 1 --num_epochs 200 --T1 200 | tee "log/seed1_nor_cifar10_pairflip_rate_0.45.log"
python Normal_training.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 2 --num_epochs 200 --T1 200 | tee "log/seed2_nor_cifar10_pairflip_rate_0.45.log"
python Normal_training.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 3 --num_epochs 200 --T1 200 | tee "log/seed3_nor_cifar10_pairflip_rate_0.45.log"
python Normal_training.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 4 --num_epochs 200 --T1 200 | tee "log/seed4_nor_cifar10_pairflip_rate_0.45.log"
python Normal_training.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 5 --num_epochs 200 --T1 200 | tee "log/seed5_nor_cifar10_pairflip_rate_0.45.log"
#python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.1 | tee "pes_cifar10_instance_rate_0.4.log"

python Norm_PH.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 1 --num_epochs 200 --T1 200 | tee "log/seed1_PH_cifar10_pairflip_rate_0.45.log"
python Norm_PH.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 2 --num_epochs 200 --T1 200 | tee "log/seed2_PH_cifar10_pairflip_rate_0.45.log"
python Norm_PH.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 3 --num_epochs 200 --T1 200 | tee "log/seed3_PH_cifar10_pairflip_rate_0.45.log"
python Norm_PH.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 4 --num_epochs 200 --T1 200 | tee "log/seed4_PH_cifar10_pairflip_rate_0.45.log"
python Norm_PH.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 5 --num_epochs 200 --T1 200 | tee "log/seed5_PH_cifar10_pairflip_rate_0.45.log"

#############################################################################################
python Norm_AM.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 1 --num_epochs 200 --T1 200 | tee "log/seed1_AM_cifar10_pairflip_rate_0.45.log"
python Norm_AM.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 2 --num_epochs 200 --T1 200 | tee "log/seed2_AM_cifar10_pairflip_rate_0.45.log"
python Norm_AM.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 3 --num_epochs 200 --T1 200 | tee "log/seed3_AM_cifar10_pairflip_rate_0.45.log"
python Norm_AM.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 4 --num_epochs 200 --T1 200 | tee "log/seed4_AM_cifar10_pairflip_rate_0.45.log"
python Norm_AM.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 5 --num_epochs 200 --T1 200 | tee "log/seed5_AM_cifar10_pairflip_rate_0.45.log"

python draw.py --Max_t 5 --noise_type pairflip --noise_rate 0.45 --num_epochs 200 --T1 200
###################################################################################################################################################################
###################################################################################################################################################################
###################################################################################################################################################################
# python Normal_training.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 200 --T1 100 | tee "log/seed1_nor_cifar10_instance_rate_0.4.log"
# python Normal_training.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 100 --T1 100 | tee "log/seed2_nor_cifar10_instance_rate_0.4.log"
# python Normal_training.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 100 --T1 100 | tee "log/seed3_nor_cifar10_instance_rate_0.4.log"
# python Normal_training.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 100 --T1 100 | tee "log/seed4_nor_cifar10_instance_rate_0.4.log"
# python Normal_training.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 100 --T1 100 | tee "log/seed5_nor_cifar10_instance_rate_0.4.log"
# #python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.1 | tee "pes_cifar10_instance_rate_0.4.log"

# python Norm_PH.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 100 --T1 100 | tee "log/seed1_PH_cifar10_instance_rate_0.4.log"
# python Norm_PH.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 100 --T1 100 | tee "log/seed2_PH_cifar10_instance_rate_0.4.log"
# python Norm_PH.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 100 --T1 100 | tee "log/seed3_PH_cifar10_instance_rate_0.4.log"
# python Norm_PH.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 100 --T1 100 | tee "log/seed4_PH_cifar10_instance_rate_0.4.log"
# python Norm_PH.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 100 --T1 100 | tee "log/seed5_PH_cifar10_instance_rate_0.4.log"

# #############################################################################################
# python Norm_AM.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 100 --T1 100 | tee "log/seed1_AM_cifar10_instance_rate_0.4.log"
# python Norm_AM.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 100 --T1 100 | tee "log/seed2_AM_cifar10_instance_rate_0.4.log"
# python Norm_AM.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 100 --T1 100 | tee "log/seed3_AM_cifar10_instance_rate_0.4.log"
# python Norm_AM.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 100 --T1 100 | tee "log/seed4_AM_cifar10_instance_rate_0.4.log"
# python Norm_AM.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 100 --T1 100 | tee "log/seed5_AM_cifar10_instance_rate_0.4.log"

# python draw --Max_t 5 --noise_type instance --noise_rate 0.4