import math
import torch


__all__ = ['CosineAnnealingWarmup']


class CosineAnnealingWarmup(torch.optim.lr_scheduler.CosineAnnealingWarmRestarts):
    def __init__(self, optimizer, T_0, T_mult=1, gamma=1.0, eta_min=0, last_epoch=-1, verbose=False):
        super().__init__(optimizer, T_0, T_mult, eta_min, last_epoch, verbose)
        self.gamma = gamma

    def get_lr(self):
        if self.T_mult == 1:
            n = self.last_epoch // self.T_0
        else:
            n = math.log(self.T_i / self.T_0, self.T_mult)

        return [self.gamma ** n * x for x in super().get_lr()]
