close all
clear 
clc

% 参数设定
sigma_HGB = 1; % 高角度GB能量
mu_HGB = 1; % 高角度GB迁移率
deltaPhi_HGB = 15; % 高角度GB的转变角度
B = 5; % Sigmoidal函数的调整参数
n = 4;

% 定义错取向角度范围
deltaPhi = linspace(0, 30, 1000);

% 计算Read-Shockley GB能量
sigma_ij = sigma_HGB .* (deltaPhi / deltaPhi_HGB) .* (1 - log(deltaPhi / deltaPhi_HGB));

% 计算Sigmoidal GB迁移率
mu_ij = mu_HGB .* (1 - exp(-B * (deltaPhi ./ deltaPhi_HGB).^n));

% 绘制GB能量
figure;
subplot(2,1,1);
plot(deltaPhi, sigma_ij, 'LineWidth', 2);
title('GB Energy vs. Misorientation Angle');
xlabel('\Delta\Phi_{ij} (degrees)');
ylabel('\sigma_{ij}(\Delta\Phi_{ij})');
grid on;

% 绘制GB迁移率
subplot(2,1,2);
plot(deltaPhi, mu_ij, 'LineWidth', 2);
title('GB Mobility vs. Misorientation Angle');
xlabel('\Delta\Phi_{ij} (degrees)');
ylabel('\mu_{ij}(\Delta\Phi_{ij})');
grid on;

% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\simulations\sim21_function.m

% (1 - exp(-B * (30 ./ 15).^n))
