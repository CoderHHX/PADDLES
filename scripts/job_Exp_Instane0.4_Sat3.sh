#!/bin/bash

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.4 --seed 1 --dataset cifar10 --T1 19 --TStop_PH 39 --num_epochs 200

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.4 --seed 2 --dataset cifar10 --T1 19 --TStop_PH 36 --num_epochs 200

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.4 --seed 3 --dataset cifar10 --T1 19 --TStop_PH 36 --num_epochs 200

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.4 --seed 4 --dataset cifar10 --T1 19 --TStop_PH 36 --num_epochs 200

python PES_cs_Fusion2_DetaB4B5.py --noise_type instance --noise_rate 0.4 --seed 5 --dataset cifar10 --T1 19 --TStop_PH 36 --num_epochs 200

python Cal_Mean_B4B5.py --Max_t 5 --noise_type instance --noise_rate 0.4 --T1 19 --exp B4B5
