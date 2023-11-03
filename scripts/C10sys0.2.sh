#!/bin/bash

#python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --T1 19 --TStop_PH 36 --num_epochs 105 --seed 2

#python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --T1 18 --TStop_PH 39 --num_epochs 120 --seed 2

#python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --T1 18 --TStop_PH 39 --num_epochs 120 --seed 1 # 92.46ss

python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --T1 18 --TStop_PH 39 --num_epochs 120 --seed 3

python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --T1 18 --TStop_PH 39 --num_epochs 120 --seed 4

python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --T1 18 --TStop_PH 39 --num_epochs 120 --seed 5


python Cal_Mean_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.2 --T1 18 --Max_t 5 
