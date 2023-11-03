#!/bin/bash
#SBATCH --time=20:00:00
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

python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 30 #--TStop_AM 30 
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 29 #--TStop_AM 30 
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 28 #--TStop_AM 30 
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 27 #--TStop_AM 30 
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 26 #--TStop_AM 30 
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 24 #--TStop_AM 30 
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 23 #--TStop_AM 30
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 22 #--TStop_AM 30
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 21 #--TStop_AM 30
python PES_cs.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 20 #--TStop_AM 30    
# python PES_cs_Fusion2.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 0 --num_epochs 200  --T1 30 --TStop_PH 40 #--TStop_AM 30 
# python draw_PES.py --Max_t 5 --noise_type symmetric --noise_rate 0.5 --num_epochs 200
