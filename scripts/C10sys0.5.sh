#!/bin/bash

python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --T1 19 --TStop_PH 39 --num_epochs 105 --seed 5

python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --T1 19 --TStop_PH 39 --num_epochs 105 --seed 4

python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --T1 19 --TStop_PH 39 --num_epochs 105 --seed 3

python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --T1 19 --TStop_PH 39 --num_epochs 105 --seed 2

python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --T1 19 --TStop_PH 39 --num_epochs 105 --seed 1

python PES_cs_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --T1 19 --TStop_PH 39 --num_epochs 105 --seed 1

python Cal_Mean_NoTest.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5 --T1 19 --Max_t 5 
