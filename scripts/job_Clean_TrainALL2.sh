#!/bin/bash
#SBATCH --time=6:00:00
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
############################################################################################
###################################################################################################################################################################
python Clean_Train2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 200 --T1 200 --batch_size 128
# python Clean_Train.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 200 --T1 200 --batch_size 256
# python Clean_Train.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 200 --T1 200 --batch_size 256
# python Clean_Train.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 200 --T1 200 --batch_size 256
# python Clean_Train.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 200 --T1 200 --batch_size 256
#python PES_cs.py --dataset cifar10 --noise_type instance --noise_rate 0.1 | tee "pes_cifar10_instance_rate_0.4.log"

python Clean_PH2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 200 --T1 200 --batch_size 128
# python Clean_PH.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 200 --T1 200 --batch_size 256
# python Clean_PH.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 200 --T1 200 --batch_size 256
# python Clean_PH.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 200 --T1 200 --batch_size 256
# python Clean_PH.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 200 --T1 200 --batch_size 256

# #############################################################################################
python Clean_AM2.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 1 --num_epochs 200 --T1 200 --batch_size 128
# python Clean_AM.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 2 --num_epochs 200 --T1 200 --batch_size 256
# python Clean_AM.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 3 --num_epochs 200 --T1 200 --batch_size 256
# python Clean_AM.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 4 --num_epochs 200 --T1 200 --batch_size 256
# python Clean_AM.py --dataset cifar10 --noise_type instance --noise_rate 0.4 --seed 5 --num_epochs 200 --T1 200 --batch_size 256

python draw_clean2.py --Max_t 1 --noise_type instance --noise_rate 0.4 --T1 200 --num_epochs 200