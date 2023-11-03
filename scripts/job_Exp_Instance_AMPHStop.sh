#!/bin/bash
#SBATCH --time=21:00:00
#SBATCH --mem=25gb
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
 
# --------------------------------------------------------------------------------
# Preparation
# You could drop some commands to setup the environment before running the code.
# E.g., activate the environment configuration files
# --------------------------------------------------------------------------------
#source /path/conda.sh  # Your conda installation
#conda activate my-env-file  # Activate the environment to run the code
 
# --------------------------------------------------------------------------------
# Running codes with a few arguments
# --------------------------------------------------------------------------------
#python myscript.py \
#--class_uniform_tile 375 \
#--result_dir ${_SAVEDIR}
module load pytorch
module load torchvision

python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 6 --num_epochs 200  --T1 18 --TStop_PH 30 #--TStop_AM 30
python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 7 --num_epochs 200  --T1 18 --TStop_PH 30 #--TStop_AM 30
python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 8 --num_epochs 200  --T1 18 --TStop_PH 30 #--TStop_AM 30
python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 9 --num_epochs 200  --T1 18 --TStop_PH 30 #--TStop_AM 30
python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 10 --num_epochs 200  --T1 18 --TStop_PH 30 #--TStop_AM 30
# python Cal_Mean.py --Max_t 5 --noise_type instance --noise_rate 0.2 --T1 18
# python draw_PES.py --Max_t 5 --noise_type instance --noise_rate 0.4 --num_epochs 100 #add seed 5

python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 6 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 7 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 8 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 9 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
python PES_cs_Fusion2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 10 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python Cal_Mean.py --Max_t 5 --noise_type instance --noise_rate 0.4 --T1 19