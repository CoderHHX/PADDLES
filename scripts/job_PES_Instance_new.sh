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
###################################################################################################################################################################
python PES_cs_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 6 --num_epochs 200 | tee "log/seed6_pes_cifar10_instance_rate_0.4.log"
python PES_cs_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 7 --num_epochs 200 | tee "log/seed7_pes_cifar10_instance_rate_0.4.log"
python PES_cs_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 8 --num_epochs 200 | tee "log/seed8_pes_cifar10_instance_rate_0.4.log"
python PES_cs_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 9 --num_epochs 200 | tee "log/seed9_pes_cifar10_instance_rate_0.4.log"
python PES_cs_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 10 --num_epochs 200 | tee "log/seed10_pes_cifar10_instance_rate_0.4.log"
###python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.1 | tee "pes_cifar10_instance_rate_0.4.log"
python PES_cs2_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 6 --num_epochs 200 | tee "log/seed6_pesPH_cifar10_instance_rate_0.4.log"
python PES_cs2_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 7 --num_epochs 200 | tee "log/seed7_pesPH_cifar10_instance_rate_0.4.log"
python PES_cs2_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 8 --num_epochs 200 | tee "log/seed8_pesPH_cifar10_instance_rate_0.4.log"
python PES_cs2_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 9 --num_epochs 200 | tee "log/seed9_pesPH_cifar10_instance_rate_0.4.log"
python PES_cs2_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 10 --num_epochs 200 | tee "log/seed10_pesPH_cifar10_instance_rate_0.4.log"
#########################
python PES_cs3_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 6 --num_epochs 200 | tee "log/seed6_pesAM_cifar10_instance_rate_0.4.log"
python PES_cs3_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 7 --num_epochs 200 | tee "log/seed7_pesAM_cifar10_instance_rate_0.4.log"
python PES_cs3_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 8 --num_epochs 200 | tee "log/seed8_pesAM_cifar10_instance_rate_0.4.log"
python PES_cs3_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 9 --num_epochs 200 | tee "log/seed9_pesAM_cifar10_instance_rate_0.4.log"
python PES_cs3_new.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 10 --num_epochs 200 | tee "log/seed10_pesAM_cifar10_instance_rate_0.4.log"

# python draw_PES.py --Max_t 5 --noise_type instance --noise_rate 0.4 --num_epochs 200  need add seed 5