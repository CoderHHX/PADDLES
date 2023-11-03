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

python PES_cs_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 6 --num_epochs 200  | tee "log/seed12_pes_cifar10_symmetric_rate_0.5.log"
python PES_cs_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 7 --num_epochs 200  | tee "log/seed22_pes_cifar10_symmetric_rate_0.5.log"
python PES_cs_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 8 --num_epochs 200  | tee "log/seed32_pes_cifar10_symmetric_rate_0.5.log"
python PES_cs_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 9 --num_epochs 200  | tee "log/seed42_pes_cifar10_symmetric_rate_0.5.log"
python PES_cs_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 10 --num_epochs 200  | tee "log/seed52_pes_cifar10_symmetric_rate_0.5.log"
# python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.1 | tee "pes_cifar10_instance_rate_0.4.log"

python PES_cs2_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 6 --num_epochs 200  | tee "log/seed12_pesPH_cifar10_symmetric_rate_0.5.log"
python PES_cs2_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 7 --num_epochs 200  | tee "log/seed22_pesPH_cifar10_symmetric_rate_0.5.log"
python PES_cs2_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 8 --num_epochs 200  | tee "log/seed32_pesPH_cifar10_symmetric_rate_0.5.log"
python PES_cs2_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 9 --num_epochs 200  | tee "log/seed42_pesPH_cifar10_symmetric_rate_0.5.log"
python PES_cs2_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 10 --num_epochs 200  | tee "log/seed52_pesPH_cifar10_symmetric_rate_0.5.log"
############################

python PES_cs3_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 6 --num_epochs 200  | tee "log/seed12_pesAM_cifar10_symmetric_rate_0.5.log"
python PES_cs3_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 7 --num_epochs 200  | tee "log/seed22_pesAM_cifar10_symmetric_rate_0.5.log"
python PES_cs3_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 8 --num_epochs 200  | tee "log/seed32_pesAM_cifar10_symmetric_rate_0.5.log"
python PES_cs3_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 9 --num_epochs 200  | tee "log/seed42_pesAM_cifar10_symmetric_rate_0.5.log"
python PES_cs3_new.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 10 --num_epochs 200  | tee "log/seed52_pesAM_cifar10_symmetric_rate_0.5.log"

# python draw_PES.py --Max_t 5 --noise_type symmetric --noise_rate 0.5 --num_epochs 200 add seed 5
