#!/bin/bash

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.2 --seed 1 --dataset cifar10 --T1 18 --TStop_PH 30 --num_epochs 200

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.2 --seed 2 --dataset cifar10 --T1 18 --TStop_PH 30 --num_epochs 200

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.2 --seed 3 --dataset cifar10 --T1 18 --TStop_PH 30 --num_epochs 200

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.2 --seed 4 --dataset cifar10 --T1 18 --TStop_PH 30 --num_epochs 200

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.2 --seed 5 --dataset cifar10 --T1 18 --TStop_PH 30 --num_epochs 200

python Cal_Mean_B4B5.py --Max_t 5 --noise_type instance --noise_rate 0.2 --T1 18 --exp B4B5
