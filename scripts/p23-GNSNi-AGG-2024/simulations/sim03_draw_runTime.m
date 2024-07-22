clear
close all
clc

% Define directory and file information
inputDir = '.\data\output\p23-GNSNi-AGG-2024\simulations\csv_kinetics\';
inputDataFiles = {'test_iso_15s', 'test_iso_15s_gt', 'test_iso_15s_fine'};
lengthNames = {'iso\_15s', 'aniso\_15s\_gt', 'aniso\_15s\_fine'};

% Visualization parameters
colors = {'#0085c3','#14d4f4','#f2af00','#b7295a','#00205b','#009f4d','#84bd00','#efdf00','#e4002b','#a51890'};
lineStyles = {'-', '-', '--', ':', '-.', '-', '-', '--', ':', '-.', '-'};
visualizationParams = struct(...
    'fontSizeXY', 14, ...
    'fontSizeLegend', 16, ...
    'fontSizeLabelTitle', 16, ...
    'lineWidth', 1.5, ...
    'colors', {colors}, ...
    'lineStyles', {lineStyles}, ...
    'width', 12, ...
    'height', 10);

% Initialize the plot
initPlot(1, visualizationParams);

% Loop over all cases
for iCases = 1:length(inputDataFiles)
  simCase = strcat('Ni700du_kinetics_', inputDataFiles{iCases}, '.csv');

  columnNames = {'time', 'runTime'};
  factorY = 1/3600;
  plotCSVDataCurve(inputDir, simCase, iCases, lengthNames{iCases}, columnNames, visualizationParams, factorY);
end

% Customize and finalize plot appearance
titles = {'Time (min)', 'Run time (h)'};
finalizePlot(visualizationParams, titles);

% scripts\p23-GNSNi-AGG-2024\simulations\sim03_draw_runTime.m
