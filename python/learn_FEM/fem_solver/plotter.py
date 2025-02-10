import matplotlib.pyplot as plt
import matplotlib.tri as tri

class Plotter:
    def __init__(self, mesh, u):
        self.mesh = mesh
        self.u = u

    def plot(self):
        nodes = self.mesh.get_nodes()
        elements = self.mesh.get_elements()
        x = nodes[:, 0]
        y = nodes[:, 1]
        # 使用三角形单元进行可视化
        triang = tri.Triangulation(x, y, elements)
        plt.tricontourf(triang, self.u, levels=20, cmap='viridis')
        plt.colorbar()
        plt.xlabel('x')
        plt.ylabel('y')
        plt.title('2D Poisson Equation FEM Solution')
        plt.show()