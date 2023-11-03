#!/bin/bash
#SBATCH --time=10:00:00
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
 
python PES_cs.py --dataset cifar100 --noise_type symmetric --noise_rate 0.2 --seed 1 --model_name resnet34 --T1 30
python PES_cs.py --dataset cifar100 --noise_type symmetric --noise_rate 0.5 --seed 1 --model_name resnet34 --T1 30
python PES_cs.py --dataset cifar100 --noise_type pairflip --noise_rate 0.45 --seed 1 --model_name resnet34 --T1 30
python PES_cs.py --dataset cifar100 --noise_type instance --noise_rate 0.2 --seed 1 --model_name resnet34 --T1 30
python PES_cs.py --dataset cifar100 --noise_type instance --noise_rate 0.4 --seed 1 --model_name resnet34 --T1 30
# python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 2
# python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 3 
# python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 4 
# python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 5 
#python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.1 | tee "pes_cifar10_instance_rate_0.4.log"