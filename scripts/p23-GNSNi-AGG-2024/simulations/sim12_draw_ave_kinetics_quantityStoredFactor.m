clear
close all
clc

% Define directory and file information
inputDir = '.\data\output\p23-GNSNi-AGG-2024\simulations\csv_kinetics\';
inputDataFiles = {'test_anisotropy_v3', 'test_anisotropy_v4'};
lengthNames = {'anisotropy\_v3', 'anisotropy\_v4', 'aniso\_15s\_fine'};

% 创建 VisualizationParams 类的实例
params = VisualizationParams();

% Initialize the plot
initPlot(1, params);

% Loop over all cases
for iCases = 1:length(inputDataFiles)
  simCase = strcat('Ni600du_kinetics_', inputDataFiles{iCases}, '.csv');

  columnNames = {'time', 'weightedAveGrainRadius'};
  plotCSVDataCurve(inputDir, simCase, iCases, lengthNames{iCases}, columnNames, params);
end

% experiment data
inputDirExp = '.\data\output\p23-GNSNi-AGG-2024\experiments\scv_kinetics\';
inputDataFilesExp = {'level1', 'level2'};
lengthNamesExp = {'Layer 1', 'Layer 2'};
% Loop over all cases
for iCases = 1:length(inputDataFiles)
  simCase = strcat('Ni700du_kinetic_', inputDataFilesExp{iCases}, '.csv');

  columnNames = {'time', 'ave_radius'};
  factors = [60, 1.0];
  plotCSVDataErrorbar(inputDirExp, simCase, iCases, lengthNamesExp{iCases}, columnNames, params, factors);
end

xlim([500 1400])
% Customize and finalize plot appearance
titles = {'Time (min)', 'Average radius (\mum)'};
finalizePlot(params, titles);

% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\simulations\sim12_draw_ave_kinetics_quantityStoredFactor.m
