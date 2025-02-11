# 实验EBSD分析  
> 20240420: SRRP-1, 广州QIS-EBSD, GNS-Ni, 5min/10min/20min/30min

## 实验-3
1. [p23_exp1_data_fill_optimization.m](./0-experiments/p23_exp1_data_fill_optimization.m): 原始数据的填充与优化处理, `done`;  
2. [p23_exp2_ipf_map.m](./0-experiments/p23_exp2_ipf_map.m): 绘制候选区域的IPF（Inverse Pole Figure）图, `done`;  
3. [p23_exp3_GND_map_and_ctf2INL_step1.m](./0-experiments/p23_exp3_GND_map_and_ctf2INL_step1.m): 绘制候选区域的GND（Geometrically Necessary Dislocations）图, `done`;  
   1.  搭配 `p23_exp3_GND_map_and_ctf2INL_step1.m` 使用，Step 1，用于MOOSE-PF模拟，将CTF数据转换为ANG格式，并输出包含rho信息的`xxx_rho.ctf`格式数据  
4.  [p23_exp4_combine_inl_and_rho_step2.m](./0-experiments/p23_exp4_combine_inl_and_rho_step2.m): Step 2，将基于ANG格式转换的INL数据与CTF格式的`rho`数据合并，生成新的`xxx_rho.inl`数据文件，用于MOOSE-PF模拟
5.  
6. [p23_exp3_gb_map.m](./0-experiments/p23_exp3_gb_map.m): 绘制候选区域的晶界（GB）图  
7. [p23_exp4_kam_map.m](./0-experiments/p23_exp4_kam_map.m): 绘制候选区域的KAM（Kernel Average Misorientation）图  
8. [p23_exp6_grain_size_distribution.m](./0-experiments/p23_exp6_grain_size_distribution.m): 获取候选区域的晶粒尺寸分布数据  
9.  [p23_exp7_grain_size_distribution_plot.m](./0-experiments/p23_exp7_grain_size_distribution_plot.m): 绘制候选区域的晶粒尺寸分布图  
10. [p23_exp8_average_grain_size_depth.m](./0-experiments/p23_exp8_average_grain_size_depth.m): 获取并绘制候选区域沿深度方向的平均晶粒尺寸  
11. [p23_exp9_orientation_difference_distribution.m](./0-experiments/p23_exp9_orientation_difference_distribution.m): 获取候选区域的取向差分布数据  
12. [p23_exp10_orientation_difference_distribution_plot.m](./0-experiments/p23_exp10_orientation_difference_distribution_plot.m): 绘制候选区域的取向差分布图  
