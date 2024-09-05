clear
close all
clc
E:\Github\MyRhinoLab\data\p23_GMSNi_AGG_2024\exp_data\layers_csv\Ni_layer1_gb.csv
% Define directory and file information
inputDir = '.\data\output\p23_GMSNi_AGG_2024\exp_data\layers_csv\';
inputDataFiles = {'Ni_layer1_gb'};
lengthNames = {'layer', 'anisotropy\_v4', 'aniso\_15s\_fine'};

% 创建 VisualizationParams 类的实例
params = VisualizationParams();

% Initialize the plot
initPlot(1, params);

% Loop over all cases
for iCases = 1:length(inputDataFiles)
  simCase = strcat('Ni600du_kinetics_', inputDataFiles{iCases}, '.csv');

  columnNames = {'time', 'weightedAveGrainRadius'};
  plotCSVDataCurveGB(inputDir, simCase, iCases, lengthNames{iCases}, columnNames, params);
end

xlim([500 1400])
% Customize and finalize plot appearance
titles = {'Time (min)', 'Average radius (\mum)'};
finalizePlot(params, titles);

% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\simulations\sim12_draw_ave_kinetics_quantityStoredFactor.m
