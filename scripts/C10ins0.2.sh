#!/bin/bash
python PES_cs_NoTest.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --T1 20 --TStop_PH 30 --num_epochs 105 --seed 1

python PES_cs_NoTest.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --T1 25 --TStop_PH 30 --num_epochs 105 --seed 1

python PES_cs_NoTest.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --T1 15 --TStop_PH 30 --num_epochs 105 --seed 1

python PES_cs_NoTest.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --T1 29 --TStop_PH 40 --num_epochs 105 --seed 1

python PES_cs_NoTest.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --T1 35 --TStop_PH 40 --num_epochs 105 --seed 1


#python Cal_Mean_NoTest.py --dataset cifar10 --noise_type instance --noise_rate 0.2 --T1 18 --Max_t 5 
