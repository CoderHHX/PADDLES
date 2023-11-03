#!/bin/bash

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 19 --TStop_PH 40 --num_epochs 200 
#

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 2 --dataset cifar100 --T1 19 --TStop_PH 40 --num_epochs 200 
#

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 3 --dataset cifar100 --T1 19 --TStop_PH 40 --num_epochs 200 
#

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 4 --dataset cifar100 --T1 19 --TStop_PH 40 --num_epochs 200 
#

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 5 --dataset cifar100 --T1 19 --TStop_PH 40 --num_epochs 200 
#

python Cal_Mean.py --Max_t 5 --noise_type symmetric --noise_rate 0.2 --T1 19

