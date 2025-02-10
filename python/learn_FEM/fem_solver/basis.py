import numpy as np  # 添加这一行

class BasisFunctions:
    def __init__(self, mesh):
        self.mesh = mesh

    def phi(self, i, x, y):
        nodes = self.mesh.get_nodes()
        xi, yi = nodes[i]
        hx = self.mesh.hx
        hy = self.mesh.hy
        return (1 - abs(x - xi) / hx) * (1 - abs(y - yi) / hy)

    def grad_phi(self, i, x, y):
        nodes = self.mesh.get_nodes()
        xi, yi = nodes[i]
        hx = self.mesh.hx
        hy = self.mesh.hy
        if x < xi:
            dx = -1 / hx
        else:
            dx = 1 / hx
        if y < yi:
            dy = -1 / hy
        else:
            dy = 1 / hy
        return np.array([dx * (1 - abs(y - yi) / hy), dy * (1 - abs(x - xi) / hx)])