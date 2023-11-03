#!/bin/bash

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 19 --TStop_PH 40 --num_epochs 200 
#69.69

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 20 --TStop_PH 40 --num_epochs 200 
#69.62

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 21 --TStop_PH 40 --num_epochs 200 
#69.19

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 22 --TStop_PH 40 --num_epochs 200 
#69.74

python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 23 --TStop_PH 40 --num_epochs 200
#69.79 

!python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 45 --num_epochs 200 
#69.56 (69.82)

!python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 40 --num_epochs 200 
#69.63(70.13) 

!python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 35 --num_epochs 200 
#69.48(

!python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 30 --num_epochs 200 
#69.25

!python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.2 --seed 1 --dataset cifar100 --T1 30 --TStop_PH 30 --num_epochs 200 
#69.23%

#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 20 --TStop_PH 33 --num_epochs 200 #60.27 

#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 20 --TStop_PH 36 --num_epochs 200 #60.03

#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 20 --TStop_PH 39 --num_epochs 200 #59.79 

#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 20 --TStop_PH 30 --num_epochs 200 #60.27 


#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 40 --num_epochs 200 #60.04 

#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 20 --TStop_PH 40 --num_epochs 200 #59.79 (60.27

#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 30 --TStop_PH 40 --num_epochs 200 # 60.24 (60.33)

#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 45 --num_epochs 200 # 59.68 (59.95)

#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 35 --num_epochs 200 # 59.85

#python PES_cs_Fusion2.py --noise_type symmetric --noise_rate 0.5 --seed 1 --dataset cifar100 --T1 25 --TStop_PH 30 --num_epochs 200  #59.46 (60.0)

#python Cal_Mean_B4B5.py --Max_t 5 --noise_type symmetric --noise_rate 0.5 --T1 19 --exp B4B5
