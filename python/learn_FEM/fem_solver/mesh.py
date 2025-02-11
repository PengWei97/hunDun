import numpy as np

class Mesh:
    def __init__(self, x_min, x_max, y_min, y_max, nx, ny):
        self.x_min = x_min
        self.x_max = x_max
        self.y_min = y_min
        self.y_max = y_max
        self.nx = nx
        self.ny = ny
        self.hx = (x_max - x_min) / nx
        self.hy = (y_max - y_min) / ny
        self.nodes = self.create_nodes()
        self.elements = self.create_elements()

    def create_nodes(self):
        nodes = []
        for i in range(self.nx + 1):
            for j in range(self.ny + 1):
                nodes.append((self.x_min + i * self.hx, self.y_min + j * self.hy))
        return np.array(nodes)

    def create_elements(self):
        elements = []
        for i in range(self.nx):
            for j in range(self.ny):
                n1 = i * (self.ny + 1) + j
                n2 = (i + 1) * (self.ny + 1) + j
                n3 = (i + 1) * (self.ny + 1) + j + 1
                n4 = i * (self.ny + 1) + j + 1
                # 将四边形拆分为两个三角形
                elements.append([n1, n2, n3])
                elements.append([n1, n3, n4])
        return np.array(elements)

    def get_nodes(self):
        return self.nodes

    def get_elements(self):
        return self.elements