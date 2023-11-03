import os
import os.path
import argparse
from pyexpat import model
import random
import time
import numpy as np
from PIL import Image

import torch
import torch.nn as nn
import torch.optim as optim
import torchvision.transforms as transforms
from torch.utils.data import Dataset, DataLoader
from torch.optim.lr_scheduler import MultiStepLR, OneCycleLR as OLR
import torchvision
import torch.backends.cudnn as cudnn
from common.tools import AverageMeter, getTime, evaluate, predict_softmax, accuracy, evaluateWithBoth, ProgressMeter
from autoaugment import CIFAR10Policy, ImageNetPolicy
import copy

# python PADDLES_Clothing1M.py --workers 24 --TStop_AM 20 --TStop_PH 29 --num_epochs 15 --lr 4.5e-3 # pct0.3 3_phase maxlr*1.9  

parser = argparse.ArgumentParser(description='PyTorch Clothing1M Training')
parser.add_argument('--seed', default=0, type=int)  
parser.add_argument('--data_root', type=str, help='data location', default='data/Clothing1M_Official/')
parser.add_argument('--data_percent', default=1, type=float, help='data number percent')
parser.add_argument('--batch_size', default=64, type=int, help='batchsize')
parser.add_argument('--lr', '--learning_rate', default=0.005, type=float, help='initial learning rate')
parser.add_argument('--weight_decay', type=float, help='weight_decay for training', default=0.001)
parser.add_argument('--workers', type=int, help='number of data loading workers (default: 8)', default=8)
parser.add_argument('--gpu_id', default='0', type=int, help='id(s) for CUDA_VISIBLE_DEVICES')
parser.add_argument('--num_classes', type=int, default=14)
parser.add_argument('--pretrain', type=str, help='pretrain', default='Yes')
parser.add_argument('--model_dir', type=str, help='dir to save model files', default='model')
parser.add_argument('--num_iters_epoch', default=10, type=int)

parser.add_argument('--num_epochs', default=5, type=int)
parser.add_argument('--TStop_AM', default=10, type=int)
parser.add_argument('--TStop_PH', default=29, type=int)
parser.add_argument('--T2', default=7, type=int, help='default 5')
parser.add_argument('--PES_lr', default=5e-6, type=float, help='initial learning rate')
parser.add_argument('--num_networks', default=2, type=int)

args = parser.parse_args()
print(args)
os.system('nvidia-smi')

if not os.path.exists(args.model_dir):
    os.system('mkdir -p %s' % (args.model_dir))

# define gpu id
args.n_gpu = torch.cuda.device_count()
if(args.n_gpu > 0):
    device = torch.device('cuda', args.gpu_id)

if args.seed is not None:
    #args.seed = random.randint(0,100)
    random.seed(args.seed)
    np.random.seed(args.seed)
    torch.manual_seed(args.seed)
    #cudnn.deterministic = True
    cudnn.benchmark = True

stop_AM = stop_PH = 0 

class Clothing1M_Dataset(Dataset):
    def __init__(self, data, labels, root_dir, transform=None, target_transform=None):
        self.train_data = np.array(data)
        self.train_labels = np.array(labels)
        self.root_dir = root_dir
        self.length = len(self.train_labels)

        if transform is None:
            self.transform = transforms.ToTensor()
        else:
            self.transform = transform

        self.target_transform = target_transform
        print("NewDataset length:", self.length)

    def __getitem__(self, index):
        img_paths, target = self.train_data[index], self.train_labels[index]

        img_paths = os.path.join(self.root_dir, img_paths)
        img = Image.open(img_paths).convert('RGB')

        if self.transform is not None:
            img = self.transform(img)

        if self.target_transform is not None:
            target = self.target_transform(target)

        return img, target

    def __len__(self):
        return self.length

    def getData(self):
        return self.train_data, self.train_labels


class Clothing1M_Unlabeled_Dataset(Dataset):
    def __init__(self, data, root_dir, transform=None):
        self.train_data = np.array(data)
        self.root_dir = root_dir
        self.length = len(self.train_data)

        if transform is None:
            self.transform = transforms.ToTensor()
        else:
            self.transform = transform

        print("NewDataset length:", self.length)

    def __getitem__(self, index):
        img_paths = self.train_data[index]
        img_paths = os.path.join(self.root_dir, img_paths)
        img = Image.open(img_paths).convert('RGB')

        if self.transform is not None:
            img1 = self.transform(img)
            img2 = self.transform(img)

        return img1, img2

    def __len__(self):
        return self.length


def create_model(pretrained):
    if(pretrained == 'Yes'):
        pretrain = True
    else:
        pretrain = False

    model = torchvision.models.resnet50(pretrained=pretrain)
    model.fc = nn.Linear(2048, args.num_classes)

    if torch.cuda.is_available:
        model.to(device)

    return model


def splite_confident(outs, noisy_targets, portion_index=None):
    probs, preds = torch.max(outs.data, 1)

    confident_indexs = []
    unconfident_indexs = []
    for i in range(0, len(noisy_targets)):
        if preds[i] == noisy_targets[i]:
            if portion_index is None:
                confident_indexs.append(i)
            else:
                confident_indexs.append(portion_index[i])
        else:
            if portion_index is None:
                unconfident_indexs.append(i)
            else:
                unconfident_indexs.append(portion_index[i])

    print(getTime(), "confident and unconfident num:", len(confident_indexs), len(unconfident_indexs))
    return confident_indexs, unconfident_indexs


def update_trainloader(model, train_data, noisy_targets, fixed_confident_indexs=None):
    predict_dataset = Clothing1M_Unlabeled_Dataset(train_data, args.data_root, transform)
    predict_loader = DataLoader(dataset=predict_dataset, batch_size=args.batch_size * 2, shuffle=False, num_workers=8, pin_memory=True, drop_last=False)
    soft_outs = predict_softmax(predict_loader, model)

    confident_indexs, unconfident_indexs = splite_confident(soft_outs, noisy_targets)
    _, preds = torch.max(soft_outs.data, 1)

    train_dataset = Clothing1M_Dataset(train_data[confident_indexs], preds[confident_indexs], args.data_root, transform, target_transform)
    trainloader = DataLoader(dataset=train_dataset, batch_size=args.batch_size, num_workers=8, pin_memory=True, shuffle=True, drop_last=True)

    # Loss function
    train_nums = np.zeros(args.num_classes, dtype=int)
    for item in preds[confident_indexs]:
        train_nums[item] += 1
    print("train categroy mean", np.mean(train_nums, dtype=int), "category", train_nums, "precent", np.mean(train_nums) / train_nums)
    class_weights = torch.FloatTensor(np.mean(train_nums) / train_nums * val_nums / np.mean(val_nums)).to(device)
    ceriation = nn.CrossEntropyLoss(weight=class_weights).to(device)

    return trainloader, None, ceriation


def noisy_refine(model, train_loader, refine_ceriation, refine_times):
    if refine_times <= 0:
        return model
    # frezon all layers and add a new final layer
    print("Begin to refine network...")
    for param in model.parameters():
        param.requires_grad = False

    model.fc = nn.Linear(2048, args.num_classes)
    model.cuda()

    optimizer_adam = torch.optim.Adam(model.parameters(), lr=args.PES_lr)
    train_iter = iter(train_loader)
    for iter_index in range(refine_times):
        train(model, train_iter, refine_ceriation, optimizer_adam, args.num_iters_epoch)
        # _, test_acc = evaluate(model, test_loader, refine_ceriation, "PADDLES Test Acc:")

    for param in model.parameters():
        param.requires_grad = True

    return model

def if_stop_AM(flag=1):
    global stop_AM
    if flag:
        stop_AM = 1
    else:
        stop_AM = 0    

def if_stop_PH(flag=1):  
    global stop_PH
    if flag:
        stop_PH = 1
    else:
        stop_PH = 0     

def detach_Freq(out, stp_AM, stp_PH):
    fft = torch.fft.fftn(out)
    im_AM,im_PH = torch.abs(fft), torch.angle(fft)
    if stp_AM:
        im_AM = im_AM.detach()
    if stp_PH:
        im_PH = im_PH.detach()
    out = torch.fft.ifftn(im_AM*(torch.exp((1j)*im_PH).cuda())).float()
    return out

def train(model, train_iter, ceriation, train_optimizer, num_prints=1, stp_AM=0, stp_PH=0):
    batch_time = AverageMeter('Time', ':6.3f')
    data_time = AverageMeter('Data', ':6.3f')
    losses = AverageMeter('Loss', ':6.3f')
    top1 = AverageMeter('Acc@1', ':6.2f')
    progress = ProgressMeter(
        len(train_iter),
        [batch_time, data_time, losses, top1], prefix="Train ")

    end = time.time()
   
    num_iter = int((len(train_iter) - 1) / num_prints)
    for batch_idx in range(num_iter):
        try:
            images, labels = train_iter.next()
            images = images.to(device, non_blocking=True)
            labels = labels.to(device, non_blocking=True)
        except StopIteration:
            break

        model.train()
        data_time.update(time.time() - end)
        train_optimizer.zero_grad()
        out = model.conv1(images)
        out = model.bn1(out)
        out = model.relu(out)
        out = model.maxpool(out)
        out = model.layer1(out)
        out = model.layer2(out) 
        out = model.layer3(out)
        if stp_AM:
            out = detach_Freq(out, stp_AM=stp_AM, stp_PH=stp_PH)   
        if stp_PH:
            out = detach_Freq(out, stp_AM=stp_AM, stp_PH=stp_PH)    
        out = model.layer4(out)
        out = model.avgpool(out)
        out = out.view(out.size(0), -1)
        logits = model.fc(out)
        loss = ceriation(logits, labels)

        loss.backward()
        train_optimizer.step() 

        acc1, acc5 = accuracy(logits, labels, topk=(1, 5))
        losses.update(loss.item(), images[0].size(0))
        top1.update(acc1[0], images[0].size(0))
        batch_time.update(time.time() - end)
        end = time.time()

    progress.display(batch_idx)
    return top1.avg, losses.avg


# Load data file
kvDic = np.load(args.data_root + 'Clothing1m-data.npy', allow_pickle=True).item()
transform = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.RandomCrop(224),
    transforms.RandomHorizontalFlip(),
    # ImageNetPolicy(), #CIFAR10Policy(), 
    transforms.ToTensor(),
    transforms.Normalize((0.6959, 0.6537, 0.6371), (0.3113, 0.3192, 0.3214)),
])

transform_test = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize((0.6959, 0.6537, 0.6371), (0.3113, 0.3192, 0.3214)),
])


def target_transform(label):
    label = np.array(label, dtype=np.int32)
    target = torch.from_numpy(label).long()
    return target


def ema(source, target, decay=0.997):
    source_dict = source.state_dict()
    target_dict = target.state_dict()
    for key in source_dict.keys():
        target_dict[key].data.copy_(target_dict[key].data * decay +
                                    source_dict[key].data * (1 - decay))

# Prepare train data loader
original_train_data = kvDic['train_data']
original_train_labels = kvDic['train_labels']
shuffle_index = np.arange(len(original_train_labels), dtype=int)
np.random.shuffle(shuffle_index)
original_train_data = original_train_data[shuffle_index]
original_train_labels = original_train_labels[shuffle_index]

clean_val_data = kvDic['clean_val_data']
clean_val_labels = kvDic['clean_val_labels']
val_nums = np.zeros(args.num_classes, dtype=int)
for item in clean_val_labels:
    val_nums[item] += 1
print("val categroy mean", np.mean(val_nums, dtype=int), "category", val_nums, "precent", val_nums / np.mean(val_nums))
clean_val_dataset = Clothing1M_Dataset(clean_val_data, clean_val_labels, args.data_root, transform_test, target_transform)
clean_val_loader = DataLoader(dataset=clean_val_dataset, batch_size=args.batch_size * 2, num_workers=args.workers, pin_memory=True, shuffle=False, drop_last=False)

test_data = kvDic['test_data']
test_labels = kvDic['test_labels']
test_dataset = Clothing1M_Dataset(test_data, test_labels, args.data_root, transform_test, target_transform)
test_loader = DataLoader(dataset=test_dataset, batch_size=args.batch_size * 2, num_workers=args.workers, pin_memory=True, shuffle=False, drop_last=False)

# Prepare new data loader
nosie_len = int(len(original_train_labels) * args.data_percent)
whole_train_data = original_train_data[:nosie_len]
whole_train_labels = original_train_labels[:nosie_len]

train_dataset = Clothing1M_Dataset(whole_train_data, whole_train_labels, args.data_root, transform, target_transform)
train_loader1 = DataLoader(dataset=train_dataset, batch_size=args.batch_size, num_workers=args.workers, pin_memory=True, shuffle=True, drop_last=True)
train_loader2 = DataLoader(dataset=train_dataset, batch_size=args.batch_size, num_workers=args.workers, pin_memory=True, shuffle=True, drop_last=True)

model1 = create_model(args.pretrain)
# ema_model1 = copy.deepcopy(model1)
optimizer1 = optim.SGD(model1.parameters(), lr=args.lr, momentum=0.9, weight_decay=args.weight_decay)#, nesterov=False)
scheduler1 = OLR(optimizer1, max_lr=(args.lr*1.9), total_steps=(args.num_epochs * args.num_iters_epoch),three_phase=True, pct_start=0.3)

model2 = create_model(args.pretrain)
# ema_model2 = copy.deepcopy(model2)
optimizer2 = optim.SGD(model2.parameters(), lr=args.lr, momentum=0.9, weight_decay=args.weight_decay)#, nesterov=False)
scheduler2 = OLR(optimizer2, max_lr=(args.lr*1.9), total_steps=(args.num_epochs * args.num_iters_epoch),three_phase=True, pct_start=0.3)

# Loss function
train_nums = np.zeros(args.num_classes, dtype=int)
for item in whole_train_labels:
    train_nums[item] += 1
print("train categroy mean", np.mean(train_nums, dtype=int), "category", train_nums, "precent", np.mean(train_nums) / train_nums)
class_weights = torch.FloatTensor(np.mean(train_nums) / train_nums * val_nums / np.mean(val_nums)).to(device)
ceriation1 = nn.CrossEntropyLoss(weight=class_weights).to(device)
ceriation2 = nn.CrossEntropyLoss(weight=class_weights).to(device)

best_val_acc = 0
best_test_acc = 0
filepath1 = args.model_dir + "/best_clothing_" + "seed" + str(args.seed) + "_1.hdf5"
filepath2 = args.model_dir + "/best_clothing_" + "seed" + str(args.seed) + "_2.hdf5"
for epoch in range(args.num_epochs):
    train_iter1 = iter(train_loader1)
    for iter_index in range(args.num_iters_epoch):
        nm_epoch = epoch * args.num_iters_epoch + iter_index
        if nm_epoch < args.TStop_AM:
            train(model1, train_iter1, ceriation1, optimizer1, args.num_iters_epoch, stp_AM=stop_AM, stp_PH=stop_PH)
        elif nm_epoch < args.TStop_PH:
            if_stop_AM(1)
            train(model1, train_iter1, ceriation1, optimizer1, args.num_iters_epoch, stp_AM=stop_AM, stp_PH=stop_PH)
        elif nm_epoch == args.TStop_PH: 
            if_stop_PH(1)
            model1 = noisy_refine(model1, train_loader1, ceriation1, args.T2)
            train_loader1, _, ceriation1 = update_trainloader(model1, whole_train_data, whole_train_labels) 
            train_iter1 = iter(train_loader1)
            continue
        else:
            if_stop_AM(0)
            if_stop_PH(0)
            train(model1, train_iter1, ceriation1, optimizer1, args.num_iters_epoch, stp_AM=stop_AM, stp_PH=stop_PH)       
        val_loss, val_acc = evaluate(model1, clean_val_loader, ceriation1, "Epoch " + str(epoch * args.num_iters_epoch + iter_index) + ", Val Acc:")
        scheduler1.step()
        # ema(model1, ema_model1)
        if(val_acc > best_val_acc):
            _, test_acc = evaluate(model1, test_loader, ceriation1, "Epoch " + str(epoch * args.num_iters_epoch + iter_index) + ", Test Acc:")
            best_val_acc = val_acc
            best_test_acc = test_acc
            torch.save(model1.state_dict(), filepath1)


print(getTime(), "Model1 Best Test Acc:", best_test_acc)


if args.num_networks == 2:
    best_val_acc2 = 0
    best_test_acc2 = 0
    for epoch in range(args.num_epochs):
        train_iter2 = iter(train_loader2)
        for iter_index in range(args.num_iters_epoch):
            nm_epoch = epoch * args.num_iters_epoch + iter_index
            if nm_epoch < args.TStop_AM:
                train(model2, train_iter2, ceriation2, optimizer2, args.num_iters_epoch, stp_AM=stop_AM, stp_PH=stop_PH)
            elif nm_epoch < args.TStop_PH:
                if_stop_AM(1)
                train(model2, train_iter2, ceriation2, optimizer2, args.num_iters_epoch, stp_AM=stop_AM, stp_PH=stop_PH)
            elif nm_epoch == args.TStop_PH: 
                if_stop_PH(1)
                model2 = noisy_refine(model2, train_loader2, ceriation2, args.T2)
                train_loader2, _, ceriation2 = update_trainloader(model2, whole_train_data, whole_train_labels)
                train_iter1 = iter(train_loader1)
                continue     
            else:
                if_stop_AM(0)
                if_stop_PH(0)
                train(model2, train_iter2, ceriation2, optimizer2, args.num_iters_epoch, stp_AM=stop_AM, stp_PH=stop_PH)       
            val_loss, val_acc = evaluate(model2, clean_val_loader, ceriation2, "Epoch " + str(epoch * args.num_iters_epoch + iter_index) + ", Val Acc:")
            scheduler2.step()
            if(val_acc > best_val_acc2):
                _, test_acc = evaluate(model2, test_loader, ceriation2, "Epoch " + str(epoch * args.num_iters_epoch + iter_index) + ", Test Acc:")
                best_val_acc2 = val_acc
                best_test_acc2 = test_acc
                torch.save(model2.state_dict(), filepath2)    

    print(getTime(), "Model1 Best Test Acc:", best_test_acc)
    print(getTime(), "Model2 Best Test Acc:", best_test_acc2)

    model1 = create_model(args.pretrain)
    model2 = create_model(args.pretrain)
    model1.load_state_dict(torch.load(filepath1))
    model2.load_state_dict(torch.load(filepath2))
    model1.eval()
    model2.eval()
    val_acc = evaluateWithBoth(model1, model2, clean_val_loader, "Epoch " + str(epoch * args.num_iters_epoch + iter_index) + ", Val Acc with both models:")
    test_acc = evaluateWithBoth(model1, model2, test_loader, "Epoch " + str(epoch * args.num_iters_epoch + iter_index) + ", Test Acc with both models:")
    best_test_acc = test_acc
    print("Clothing1M best test acc:", best_test_acc)
