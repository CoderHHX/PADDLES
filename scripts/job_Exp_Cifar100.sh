#!/bin/bash

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 30 --TStop_PH 40 --num_epochs 200 --model_name renet34 
# 70.31

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.4 --seed 1 --dataset cifar100 --T1 30 --TStop_PH 40 --num_epochs 200 --model_name renet34 
# 62.24
 
python PES_cs_Fusion2.py --noise_type pairflip --noise_rate 0.45 --seed 1 --dataset cifar100 --T1 30 --TStop_PH 40 --num_epochs 200 --model_name renet34
#7

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 30 --TStop_PH 40 --num_epochs 200 --model_name renet34 
#69.63(70.13)

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 30 --TStop_PH 40 --num_epochs 200 --model_name renet34 
# 70.37

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.4 --seed 1 --dataset cifar100 --T1 30 --TStop_PH 40 --num_epochs 200 --model_name renet34 
# 62.24
 
python PES_cs_Fusion2.py --noise_type pairflip --noise_rate 0.45 --seed 1 --dataset cifar100 --T1 30 --TStop_PH 40 --num_epochs 200 --model_name renet34


---------------------------------------------------------------------
python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 40 --num_epochs 200 --model_name renet34 
# 70.37

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.4 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 40 --num_epochs 200 --model_name renet34 
#70.31
 
python PES_cs_Fusion2.py --noise_type pairflip --noise_rate 0.45 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 40 --num_epochs 200 --model_name renet34

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 40 --num_epochs 200 --model_name renet34 
#69.63(70.13)

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 40 --num_epochs 200 --model_name renet34 
# 70.37

python PES_cs_Fusion2.py --noise_type instance --noise_rate 0.4 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 40 --num_epochs 200 --model_name renet34 
# 62.24
 
python PES_cs_Fusion2.py --noise_type pairflip --noise_rate 0.45 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 40 --num_epochs 200 --model_name renet34 
# 
