close all
clear 
clc

% 参数设定
mu_0 = 1; % 高角度GB迁移率
deltaStoredEnergy_High = 90; % 高角度GB的转变角度
B = 5; % Sigmoidal函数的调整参数
n = 4;

% 定义存储能差范围
deltaStoredEnergy = linspace(0, 120, 1000);

% 计算Sigmoidal GB迁移率
mu_ij = mu_0 .* (1 - exp(-B * (deltaStoredEnergy ./ deltaStoredEnergy_High).^n));

% 绘制GB迁移率
plot(deltaStoredEnergy, mu_ij, 'LineWidth', 2);
title('GB Mobility vs. Stored Energy Difference');
xlabel('\delta f_{s} (degrees)');
ylabel('\mu_{ij}');
grid on;

ylim([-0.1 1.1]);
% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\simulations\sim21_function2.m

% (1 - exp(-B * (30 ./ 15).^n))
