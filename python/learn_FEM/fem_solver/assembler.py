import numpy as np

class Assembler:
    def __init__(self, mesh, basis):
        self.mesh = mesh
        self.basis = basis

    def assemble_stiffness_matrix(self):
        nodes = self.mesh.get_nodes()
        elements = self.mesh.get_elements()
        N = len(nodes)
        K = np.zeros((N, N))

        for element in elements:
            for i in element:
                for j in element:
                    K[i, j] += np.sum([np.dot(self.basis.grad_phi(i, x, y), self.basis.grad_phi(j, x, y)) for x, y in nodes[element]]) * self.mesh.hx * self.mesh.hy / 4

        return K

    def assemble_load_vector(self, f):
        nodes = self.mesh.get_nodes()
        elements = self.mesh.get_elements()
        N = len(nodes)
        F = np.zeros(N)

        for element in elements:
            for i in element:
                F[i] += np.sum([f(x, y) * self.basis.phi(i, x, y) for x, y in nodes[element]]) * self.mesh.hx * self.mesh.hy / 4

        return F