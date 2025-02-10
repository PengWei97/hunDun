from fem_solver.mesh import Mesh
from fem_solver.basis import BasisFunctions
from fem_solver.assembler import Assembler
from fem_solver.solver import Solver
from fem_solver.plotter import Plotter

import numpy as np

# 定义外力函数
def f(x, y):
    return 0.0  # 这里假设外力为 0

# 参数设置
x_min, x_max = 0.0, 1.0
y_min, y_max = 0.0, 1.0
nx, ny = 100, 100

# 创建网格
mesh = Mesh(x_min, x_max, y_min, y_max, nx, ny)

# 创建基函数
basis = BasisFunctions(mesh)

# 组装刚度矩阵和载荷向量
assembler = Assembler(mesh, basis)
K = assembler.assemble_stiffness_matrix()
F = assembler.assemble_load_vector(f)

# 应用边界条件
nodes = mesh.get_nodes()
N = len(nodes)
for i in range(N):
    x, y = nodes[i]
    if np.isclose(x, 0.0):  # 左边界
        K[i, :] = 0
        K[i, i] = 1
        F[i] = 1  # u = 1
    elif np.isclose(x, 1.0):  # 右边界
        K[i, :] = 0
        K[i, i] = 1
        F[i] = 0  # u = 0

# 求解线性方程组
solver = Solver(K, F)
u = solver.solve()

# 绘制结果
plotter = Plotter(mesh, u)
plotter.plot()