# Paddles: Phase-amplitude spectrum disentangled early stopping for learning with noisy labels

<div style="text-align: center;">
    <img src="Detach.png" width=100% >
</div>

PyTorch Code for the following paper at ICCV 2023:\
<b>Title</b>: [Paddles: Phase-amplitude spectrum disentangled early stopping for learning with noisy labels](https://openaccess.thecvf.com/content/ICCV2023/papers/Huang_PADDLES_Phase-Amplitude_Spectrum_Disentangled_Early_Stopping_for_Learning_with_Noisy_ICCV_2023_paper.pdf).\
<b>Authors</b>: Huaxi Huang*, Hui Kang*, Sheng Liu, Olivier Salvado, Thierry Rakotoarivelo,  Dadong Wang and Tongliang Liu


## Abstract

Convolutional Neural Networks (CNNs) are powerful in learning patterns of different vision tasks, but they are sensitive to label noise and may overfit to noisy labels during training. The early stopping strategy averts updating CNNs during the early training phase and is widely employed in the presence of noisy labels. Motivated by biological findings that the amplitude spectrum (AS) and phase spectrum (PS) in the frequency domain play different roles in the animal's vision system, we observe that PS, which captures more semantic information, can increase the robustness of CNNs to label noise, more so than AS can. We thus propose early stops at different times for AS and PS by disentangling the features of some layer (s) into AS and PS using Discrete Fourier Transform (DFT) during training. Our proposed Phase-AmplituDe DisentangLed Early Stopping (PADDLES) method is shown to be effective on both synthetic and real-world label-noise datasets. PADDLES outperforms other early stopping methods and obtains state-of-the-art performance.

## Experiments

To install requirements:

```setup
pip install -r requirements.txt
```

> 📋 Please download and place all datasets into the data directory. For Clohting1M, please run "python ClothingData.npy" to generate a data file.

To train PADDLES without semi on CIFAR-10/100

```
python PES_cs_Fusion2.py --dataset cifar10 --noise_type symmetric --noise_rate 0.5
```

```
python PES_cs_Fusion2.py --dataset cifar100 --noise_type instance --noise_rate 0.4
```

To train PADDLES with semi on CIFAR-10/100

```
python PES_semi_Fusion2.py --dataset cifar100 --noise_type symmetirc --noise_rate 0.8 --lambda_u 100 --num_epochs 300 --T1 18 --TStop_PH 30 --seed 1
python PES_semi_Fusion2.py --dataset cifar100 --noise_type symmetirc --noise_rate 0.5 --lambda_u 75  --num_epochs 300 --T1 18 --TStop_PH 30 --seed 1
python PES_semi_Fusion2.py --dataset cifar100 --noise_type symmetirc --noise_rate 0.2 --lambda_u 50  --num_epochs 300 --T1 18 --TStop_PH 30 --seed 1
```


To train PADDLES on Clothing1M

```train Clothing1M
python PES_Clothing1M_New2.py
```

We also evaluate our method on [CIFAR-N Dataset](http://www.noisylabels.com/)
···
Mv CIFAR-10_human.pt and CIFAR-100_human.pt to data/
```
python PES_noisylabels_Fusion.py --noise_type aggre_label --dataset CIFAR10 --seed 1 --TStop_AM 20 --TStop_PH 30 
```

```
python PES_noisylabels_Fusion.py --noise_type random_label1 --dataset CIFAR10 --seed 1 --TStop_AM 20 --TStop_PH 30 
```

```
python PES_noisylabels_Fusion.py --noise_type random_label2 --dataset CIFAR10 --seed 1 --TStop_AM 20 --TStop_PH 30 
```

```
python PES_noisylabels_Fusion2.py --noise_type random_label3 --dataset CIFAR10 --seed 1 --TStop_AM 30 --TStop_PH 35 --train 1 #seed=1 train=1 acc=96.25
```

```
python PES_noisylabels_Fusion2.py --noise_type worse_label --dataset CIFAR10 --seed 1 --TStop_AM 25 --TStop_PH 30 --train 1 
```

```
python PES_noisylabels_Fusion2.py --dataset CIFAR100 --seed 1 --TStop_AM 30--TStop_PH 35 --train 1  
```


## Cite PADDLES
If you find the code useful in your research, please consider citing our paper:

<pre>
@InProceedings{Huang_2023_ICCV,
    author    = {Huang, Huaxi and Kang, Hui and Liu, Sheng and Salvado, Olivier and Rakotoarivelo, Thierry and Wang, Dadong and Liu, Tongliang},
    title     = {PADDLES: Phase-Amplitude Spectrum Disentangled Early Stopping for Learning with Noisy Labels},
    booktitle = {Proceedings of the IEEE/CVF International Conference on Computer Vision (ICCV)},
    month     = {October},
    year      = {2023},
    pages     = {16719-16730}
}
</pre>
