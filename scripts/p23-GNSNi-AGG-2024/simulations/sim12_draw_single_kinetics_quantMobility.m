clear
close all
clc

% Define directory and file information
inputDir = '.\data\output\p23-GNSNi-AGG-2024\simulations\paramQuant\gBMobility\';
% inputDataFiles = {'v1_sigma3', 'v2_sigma3', 'v3_sigma3', 'v4_sigma3'};
% lengthNames = {'v1 sigma3', 'v2 sigma3', 'v3 sigma3', 'v4 sigma3' };

inputDataFiles = {'v1_region4'};
lengthNames = {'v1 region4'};

% grainIDs = [97, 57, 42]; % region-1
grainIDs = [60, 69, 99]; % region-4 
lengthNames = {'Sim-Gr60', 'Sim-Gr69', 'Sim-Gr99', 'Sim-Gr118'};

% 创建 VisualizationParams 类的实例
params = VisualizationParams();

% Initialize the plot
initPlot(1, params);

% Loop over all cases
for iCases = 1:length(inputDataFiles)
  simCase = strcat('Ni600du_kinetics_', inputDataFiles{iCases}, '.csv');

  for iGrainID = 1:length(grainIDs)
    columnName_gr = sprintf('gr%d', grainIDs(iGrainID));
    columnNames = {'time', columnName_gr};
    plotCSVDataCurve(inputDir, simCase, iGrainID, lengthNames{iGrainID}, columnNames, params);
  end
end

% experiment data
inputDirExp = inputDir;
inputDataFilesExp = {'exp_region4'}; % Ni600du_kinetics_exp_sigma3.csv
lengthNamesExp = {'Exp-Gr60', 'Exp-Gr69', 'Exp-Gr99', 'Exp-Gr118'};
% Loop over all cases
for iCases = 1:length(inputDataFilesExp)
  simCase = strcat('Ni600du_kinetics_', inputDataFilesExp{iCases}, '.csv');

  for iGrainID = 1:length(grainIDs)
    columnName_gr = sprintf('gr%d', grainIDs(iGrainID));
    columnNames = {'time', columnName_gr};
    plotCSVDataScatter(inputDirExp, simCase, iGrainID, lengthNamesExp{iGrainID}, columnNames, params);
  end
end

ylim([4 22])
% % Customize and finalize plot appearance
titles = {'Time (min)', 'Grain radius (\mum)'};
finalizePlot(params, titles);

% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\simulations\sim12_draw_single_kinetics_quantMobility.m
