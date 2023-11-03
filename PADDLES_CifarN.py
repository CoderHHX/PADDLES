import os
import os.path
import argparse
import random
import numpy as np

import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
import torch.backends.cudnn as cudnn
import torchvision.transforms as transforms
from torch.utils.data import DataLoader
from torch.optim.lr_scheduler import MultiStepLR, CosineAnnealingLR
from torchvision.datasets import CIFAR10, CIFAR100

from networks.ResNet_New_DetachB4B5 import ResNet34
from common.tools import AverageMeter, getTime, evaluate, predict_softmax, train
from common.NoisyUtil import Train_Dataset, Semi_Labeled_Dataset, Semi_Unlabeled_Dataset
from autoaugment import CIFAR10Policy, ImageNetPolicy
from utils import CosineAnnealingWarmup


parser = argparse.ArgumentParser(description='PyTorch CIFAR-N Training')
parser.add_argument('--seed', default=1, type=int)
parser.add_argument('--dataset', default='cifar10', type=str)
parser.add_argument('--data_path', type=str, default='./data', help='data directory')
parser.add_argument('--data_percent', default=1, type=float, help='data number percent')
parser.add_argument('--noise_type', default='aggre_label', type=str, help='worse_label, aggre_label, random_label1, random_label2, random_label3')
parser.add_argument('--batch_size', default=128, type=int, help='train batchsize')
parser.add_argument('--lr', '--learning_rate', default=0.02, type=float, help='initial learning rate')
parser.add_argument('--weight_decay', type=float, help='weight_decay for training', default=5e-4)
parser.add_argument('--num_epochs', default=300, type=int)
parser.add_argument('--optim', default='cos', type=str, help='step, cos, sgdr')

parser.add_argument('--alpha', default=4, type=float, help='parameter for Beta')
parser.add_argument('--T', default=0.5, type=float, help='sharpening temperature')
parser.add_argument('--lambda_u', default=0, type=float, help='weight for unsupervised loss')
parser.add_argument('--PES_lr', default=1e-4, type=float, help='initial learning rate')
parser.add_argument('--T2', default=5, type=int, help='default 5')
parser.add_argument('--TStop_AM', default=20, type=int)
parser.add_argument('--TStop_PH', default=30, type=int)
parser.add_argument('--workers', type=int, help='number of data loading workers (default: 16)', default=16)
parser.add_argument('--train', default=1, type=int)

args = parser.parse_args()
print(args)
os.system('nvidia-smi')


args.model_dir = 'model/'
if not os.path.exists(args.model_dir):
    os.system('mkdir -p %s' % (args.model_dir))

if args.seed is not None:
    random.seed(args.seed)
    np.random.seed(args.seed)
    torch.manual_seed(args.seed)
    cudnn.deterministic = True
    # cudnn.benchmark = True


def create_model(num_classes=10):
    model = ResNet34(num_classes)
    model.cuda()
    return model


def write_logs(title, args, best_test_acc):
    f = open("./logs/results.txt", "a")
    if args is not None:
        f.write("\n" + getTime() + " " + str(args) + "\n")
    f.write(getTime() + " " + title + " seed-" + str(args.seed) + ", Best Test Acc: " + str(best_test_acc) + "\n")
    f.close()


def linear_rampup(current, warm_up=20, rampup_length=16):
    current = np.clip((current - warm_up) / rampup_length, 0.0, 1.0)
    return args.lambda_u * float(current)


# MixMatch Training
def MixMatch_train(epoch, net, optimizer, labeled_trainloader, unlabeled_trainloader, class_weights):
    net.train()
    if epoch >= args.num_epochs / 2:
        args.alpha = 0.75

    losses = AverageMeter('Loss', ':6.2f')
    losses_lx = AverageMeter('Loss_Lx', ':6.2f')
    losses_lu = AverageMeter('Loss_Lu', ':6.5f')

    labeled_train_iter = iter(labeled_trainloader)
    unlabeled_train_iter = iter(unlabeled_trainloader)
    num_iter = int(50000 / args.batch_size)
    for batch_idx in range(num_iter):
        try:
            inputs_x, inputs_x2, targets_x = labeled_train_iter.next()
        except StopIteration:
            labeled_train_iter = iter(labeled_trainloader)
            inputs_x, inputs_x2, targets_x = labeled_train_iter.next()

        try:
            inputs_u, inputs_u2 = unlabeled_train_iter.next()
        except StopIteration:
            unlabeled_train_iter = iter(unlabeled_trainloader)
            inputs_u, inputs_u2 = unlabeled_train_iter.next()

        batch_size = inputs_x.size(0)
        targets_x = torch.zeros(batch_size, args.num_class).scatter_(1, targets_x.view(-1, 1), 1)
        inputs_x, inputs_x2, targets_x = inputs_x.cuda(), inputs_x2.cuda(), targets_x.cuda()
        inputs_u, inputs_u2 = inputs_u.cuda(), inputs_u2.cuda()

        with torch.no_grad():
            outputs_u11 = net(inputs_u)
            outputs_u12 = net(inputs_u2)

            pu = (torch.softmax(outputs_u11, dim=1) + torch.softmax(outputs_u12, dim=1)) / 2
            ptu = pu**(1 / args.T)  # temparature sharpening

            targets_u = ptu / ptu.sum(dim=1, keepdim=True)  # normalize
            targets_u = targets_u.detach()

        all_inputs = torch.cat([inputs_x, inputs_x2, inputs_u, inputs_u2], dim=0)
        all_targets = torch.cat([targets_x, targets_x, targets_u, targets_u], dim=0)

        idx = torch.randperm(all_inputs.size(0))
        input_a, input_b = all_inputs, all_inputs[idx]
        target_a, target_b = all_targets, all_targets[idx]

        mixmatch_l = np.random.beta(args.alpha, args.alpha)
        mixmatch_l = max(mixmatch_l, 1 - mixmatch_l)

        mixed_input = mixmatch_l * input_a + (1 - mixmatch_l) * input_b
        mixed_target = mixmatch_l * target_a + (1 - mixmatch_l) * target_b

        logits = net(mixed_input)
        logits_x = logits[:batch_size * 2]
        logits_u = logits[batch_size * 2:]

        Lx_mean = -torch.mean(F.log_softmax(logits_x, dim=1) * mixed_target[:batch_size * 2], 0)
        Lx = torch.sum(Lx_mean * class_weights)

        probs_u = torch.softmax(logits_u, dim=1)
        Lu = torch.mean((probs_u - mixed_target[batch_size * 2:])**2)
        loss = Lx + linear_rampup(epoch + batch_idx / num_iter, args.T1) * Lu

        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        losses_lx.update(Lx.item(), batch_size * 2)
        losses_lu.update(Lu.item(), len(logits) - batch_size * 2)
        losses.update(loss.item(), len(logits))

    print(losses, losses_lx, losses_lu)


def splite_confident(outs, clean_targets, noisy_targets):
    probs, preds = torch.max(outs.data, 1)

    confident_correct_num = 0
    unconfident_correct_num = 0
    confident_indexs = []
    unconfident_indexs = []

    for i in range(0, len(noisy_targets)):
        if preds[i] == noisy_targets[i]:
            confident_indexs.append(i)
            if clean_targets[i] == preds[i]:
                confident_correct_num += 1
        else:
            unconfident_indexs.append(i)
            if clean_targets[i] == preds[i]:
                unconfident_correct_num += 1

    # print(getTime(), "confident and unconfident num:", len(confident_indexs), round(confident_correct_num / len(confident_indexs) * 100, 2), len(unconfident_indexs), round(unconfident_correct_num / len(unconfident_indexs) * 100, 2))
    return confident_indexs, unconfident_indexs


def update_trainloader(model, train_data, clean_targets, noisy_targets):
    predict_dataset = Semi_Unlabeled_Dataset(train_data, transform_train)
    predict_loader = DataLoader(dataset=predict_dataset, batch_size=args.batch_size * 2, shuffle=False, num_workers=args.workers, pin_memory=True, drop_last=False)
    soft_outs = predict_softmax(predict_loader, model)

    confident_indexs, unconfident_indexs = splite_confident(soft_outs, clean_targets, noisy_targets)
    confident_dataset = Semi_Labeled_Dataset(train_data[confident_indexs], noisy_targets[confident_indexs], transform_train)
    unconfident_dataset = Semi_Unlabeled_Dataset(train_data[unconfident_indexs], transform_train)

    uncon_batch = int(args.batch_size / 2) if len(unconfident_indexs) > len(confident_indexs) else int(len(unconfident_indexs) / (len(confident_indexs) + len(unconfident_indexs)) * args.batch_size)
    con_batch = args.batch_size - uncon_batch

    labeled_trainloader = DataLoader(dataset=confident_dataset, batch_size=con_batch, shuffle=True, num_workers=args.workers, pin_memory=True, drop_last=True)
    unlabeled_trainloader = DataLoader(dataset=unconfident_dataset, batch_size=uncon_batch, shuffle=True, num_workers=args.workers, pin_memory=True, drop_last=True)

    # Loss function
    train_nums = np.zeros(args.num_class, dtype=int)
    for item in noisy_targets[confident_indexs]:
        train_nums[item] += 1

    # zeros are not calculated by mean
    # avoid too large numbers that may result in out of range of loss.
    with np.errstate(divide='ignore'):
        cw = np.mean(train_nums[train_nums != 0]) / train_nums
        cw[cw == np.inf] = 0
        cw[cw > 3] = 3
    class_weights = torch.FloatTensor(cw).cuda()
    # print("Category", train_nums, "precent", class_weights)
    return labeled_trainloader, unlabeled_trainloader, class_weights


def noisy_refine(model, train_loader, num_layer, refine_times):
    if refine_times <= 0:
        return model
    # frezon all layers and add a new final layer
    for param in model.parameters():
        param.requires_grad = False

    model.renew_layers(num_layer)
    model.cuda()

    optimizer_adam = torch.optim.Adam(model.parameters(), lr=args.PES_lr)
    for epoch in range(refine_times):
        train(model, train_loader, optimizer_adam, ceriation, epoch)
        _, test_acc = evaluate(model, test_loader, ceriation, "Epoch " + str(epoch) + " Test Acc:")

    for param in model.parameters():
        param.requires_grad = True

    return model


if args.dataset == 'cifar10' or args.dataset == 'CIFAR10':
    args.num_class = 10
    transform_train = transforms.Compose([
        transforms.RandomCrop(32, padding=4),
        transforms.RandomHorizontalFlip(),
        CIFAR10Policy(),
        transforms.ToTensor(),
        transforms.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010)),
    ])
    transform_test = transforms.Compose([transforms.ToTensor(), transforms.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010))])
    train_set = CIFAR10(root=args.data_path, train=True, download=True)
    test_set = CIFAR10(root=args.data_path, train=False, transform=transform_test, download=True)

    args.lambda_u = 5
    # For CIFAR-10N noisy labels
    data = train_set.data
    cifar_n_label = torch.load('data/CIFAR-10_human.pt')
    clean_labels = cifar_n_label['clean_label']

    if args.noise_type == "worse_label":
        noisy_labels = cifar_n_label['worse_label']
    elif args.noise_type == "aggre_label":
        noisy_labels = cifar_n_label['aggre_label']
    elif args.noise_type == "random_label1":
        noisy_labels = cifar_n_label['random_label1']
    elif args.noise_type == 'random_label2':
        noisy_labels = cifar_n_label['random_label2']
    elif args.noise_type == 'random_label3':
        noisy_labels = cifar_n_label['random_label3']
elif args.dataset == 'cifar100' or args.dataset == 'CIFAR100':
    args.num_class = 100
    transform_train = transforms.Compose([
        transforms.RandomCrop(32, padding=4),
        transforms.RandomHorizontalFlip(),
        CIFAR10Policy(), #cifar for v23 70.58
        #ImageNetPolicy(), #image for s4  68.04
        transforms.ToTensor(),
        transforms.Normalize((0.507, 0.487, 0.441), (0.267, 0.256, 0.276)),
    ])
    transform_test = transforms.Compose([transforms.ToTensor(), transforms.Normalize((0.507, 0.487, 0.441), (0.267, 0.256, 0.276))])
    train_set = CIFAR100(root=args.data_path, train=True, download=True)
    test_set = CIFAR100(root=args.data_path, train=False, transform=transform_test, download=True)

    args.lambda_u = 75
    # For CIFAR-100N noisy labels
    data = train_set.data
    cifar_n_label = torch.load('data/CIFAR-100_human.pt')
    clean_labels = cifar_n_label['clean_label']
    noisy_labels = cifar_n_label['noisy_label']


ceriation = nn.CrossEntropyLoss().cuda()

train_dataset = Train_Dataset(data, noisy_labels, transform_train)
train_loader = DataLoader(dataset=train_dataset, batch_size=args.batch_size, shuffle=True, num_workers=args.workers, pin_memory=True, drop_last=True)
test_loader = DataLoader(dataset=test_set, batch_size=args.batch_size * 2, shuffle=False, num_workers=args.workers, pin_memory=True)

model = create_model(num_classes=args.num_class)
optimizer = optim.SGD(model.parameters(), lr=args.lr, momentum=0.9, weight_decay=args.weight_decay)
if args.optim == 'cos':
    scheduler = CosineAnnealingLR(optimizer, args.num_epochs, args.lr / 100)
elif args.optim == 'sgdr':
    scheduler = CosineAnnealingWarmup(optimizer, T_0=100, T_mult=2, gamma=2/3)
else:
    scheduler = MultiStepLR(optimizer, milestones=[150, 250], gamma=0.1)

best_test_acc = 0
for epoch in range(args.num_epochs):
    if epoch < args.TStop_AM:
        train(model, train_loader, optimizer, ceriation, epoch)
    elif epoch < args.TStop_PH: 
        model.if_stop_AM(1)
        train(model, train_loader, optimizer, ceriation, epoch)
    elif epoch == args.TStop_PH:
        model.if_stop_PH(1)
        if args.train > 0:
            for i in range(args.train): 
                train(model, train_loader, optimizer, ceriation, (epoch+i)) 
                
        model = noisy_refine(model, train_loader, 0, args.T2)
        labeled_trainloader, unlabeled_trainloader, class_weights = update_trainloader(model, data, clean_labels, noisy_labels)
        model.if_stop_AM(0)
        model.if_stop_PH(0)
        MixMatch_train(epoch, model, optimizer, labeled_trainloader, unlabeled_trainloader, class_weights)
    else:
        model.if_stop_AM(0)
        model.if_stop_PH(0)
        labeled_trainloader, unlabeled_trainloader, class_weights = update_trainloader(model, data, clean_labels, noisy_labels)
        MixMatch_train(epoch, model, optimizer, labeled_trainloader, unlabeled_trainloader, class_weights)
  
    _, test_acc = evaluate(model, test_loader, ceriation, "Epoch " + str(epoch) + " Test Acc:")
    best_test_acc = test_acc if best_test_acc < test_acc else best_test_acc
    scheduler.step()

print(getTime(), "Best Test Acc:", best_test_acc)
write_logs("Noisylabels:", args, best_test_acc)
