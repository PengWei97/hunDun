import numpy as np

class Solver:
    def __init__(self, K, F):
        self.K = K
        self.F = F

    def solve(self):
        return np.linalg.solve(self.K, self.F)