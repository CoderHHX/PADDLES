#!/bin/bash

#python PES_cs_NoTest.py --dataset cifar100 --noise_type symmetric --noise_rate 0.5 --T1 20 --TStop_PH 33 --num_epochs 105 --seed 5

#python PES_cs_NoTest.py --dataset cifar100 --noise_type symmetric --noise_rate 0.5 --T1 20 --TStop_PH 33 --num_epochs 105 --seed 4

python PES_cs_NoTest.py --dataset cifar100 --noise_type symmetric --noise_rate 0.5 --T1 20 --TStop_PH 33 --num_epochs 200 --seed 3

#python PES_cs_NoTest.py --dataset cifar100 --noise_type symmetric --noise_rate 0.5 --T1 20 --TStop_PH 33 --num_epochs 105 --seed 2

#python PES_cs_NoTest.py --dataset cifar100 --noise_type symmetric --noise_rate 0.5 --T1 20 --TStop_PH 33 --num_epochs 105 --seed 1

#python PES_cs_NoTest.py --dataset cifar100 --noise_type symmetric --noise_rate 0.5 --T1 20 --TStop_PH 33 --num_epochs 105 --seed 1

python Cal_Mean_NoTest.py --dataset cifar100 --noise_type symmetric --noise_rate 0.5 --T1 20 --Max_t 5 
