#!/bin/bash

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.4 --seed 1 --dataset cifar100 --T1 35 --TStop_PH 45 --num_epochs 200 
#

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.4 --seed 2 --dataset cifar100 --T1 35 --TStop_PH 45 --num_epochs 200 
#

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.4 --seed 3 --dataset cifar100 --T1 35 --TStop_PH 45 --num_epochs 200 
#

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.4 --seed 4 --dataset cifar100 --T1 35 --TStop_PH 45 --num_epochs 200 
#

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.4 --seed 5 --dataset cifar100 --T1 35 --TStop_PH 45 --num_epochs 200 
#
python Cal_mean.py --Max_t 5 --noise_type instance --noise_rate 0.4 --T1 35
