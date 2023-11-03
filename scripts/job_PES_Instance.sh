#!/bin/bash
#SBATCH --time=02:00:00
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
###################################################################################################################################################################
# python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 200 | tee "log/seed1_pes_cifar10_instance_rate_0.4.log"
# python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 200 | tee "log/seed2_pes_cifar10_instance_rate_0.4.log"
# python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 200 | tee "log/seed3_pes_cifar10_instance_rate_0.4.log"
# python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 200 | tee "log/seed4_pes_cifar10_instance_rate_0.4.log"
# python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 200 | tee "log/seed5_pes_cifar10_instance_rate_0.4.log"
#python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.1 | tee "pes_cifar10_instance_rate_0.4.log"
# python PES_cs2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 200 | tee "log/seed1_pesPH_cifar10_instance_rate_0.4.log"
# python PES_cs2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 200 | tee "log/seed2_pesPH_cifar10_instance_rate_0.4.log"
# python PES_cs2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 200 | tee "log/seed3_pesPH_cifar10_instance_rate_0.4.log"
# python PES_cs2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 200 | tee "log/seed4_pesPH_cifar10_instance_rate_0.4.log"
# python PES_cs2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 200 | tee "log/seed5_pesPH_cifar10_instance_rate_0.4.log"
##########################
# python PES_cs3.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 200 | tee "log/seed1_pesAM_cifar10_instance_rate_0.4.log"
# python PES_cs3.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 200 | tee "log/seed2_pesAM_cifar10_instance_rate_0.4.log"
# python PES_cs3.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 200 | tee "log/seed3_pesAM_cifar10_instance_rate_0.4.log"
# python PES_cs3.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 200 | tee "log/seed4_pesAM_cifar10_instance_rate_0.4.log"
python PES_cs3.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 200 | tee "log/seed5_pesAM_cifar10_instance_rate_0.4.log"

python draw_PES.py --Max_t 5 --noise_type instance --noise_rate 0.4 --num_epochs 200