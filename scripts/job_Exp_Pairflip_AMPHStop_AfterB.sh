#!/bin/bash
#SBATCH --time=4:00:00
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

python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 5 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30

# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --seed 1 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --seed 2 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --seed 3 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --seed 4 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --seed 5 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python Cal_Mean.py --Max_t 5 --noise_type symmetric --noise_rate 0.2 --T1 19

# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 1 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 2 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 3 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 4 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --seed 5 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python Cal_Mean.py --Max_t 5 --noise_type symmetric --noise_rate 0.5 --T1 19

# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 1 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 2 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 3 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 4 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --seed 5 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python Cal_Mean.py --Max_t 5 --noise_type instance --noise_rate 0.2 --T1 19

# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python Cal_Mean.py --Max_t 5 --noise_type instance --noise_rate 0.4 --T1 19


# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 1 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 2 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 3 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 4 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2_AfterB4.py --dataset cifar10 --noise_type pairflip --noise_rate 0.45 --seed 5 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python Cal_Mean.py --Max_t 5 --noise_type pairflip --noise_rate 0.45 --T1 19
# python draw_PES.py --Max_t 5 --noise_type pairflip --noise_rate 0.4 --num_epochs 100 #add seed 5

# python PES_cs_Fusion2.py --dataset cifar10 --noise_type pairflip --noise_rate 0.5 --seed 1 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2.py --dataset cifar10 --noise_type pairflip --noise_rate 0.5 --seed 2 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2.py --dataset cifar10 --noise_type pairflip --noise_rate 0.5 --seed 3 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2.py --dataset cifar10 --noise_type pairflip --noise_rate 0.5 --seed 4 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python PES_cs_Fusion2.py --dataset cifar10 --noise_type pairflip --noise_rate 0.5 --seed 5 --num_epochs 200  --T1 19 --TStop_PH 39 #--TStop_AM 30
# python Cal_Mean.py --Max_t 5 --noise_rate pairflip 0.4 --T1 19