% ---------------------------------------------------------
% Script Name: mtex5_draw_gb_map.m
% Created by: Peng Wei
% Date: October 17, 2024
% Purpose: To visualize grain boundary maps of GNSNi samples 
%          using Taichang's EBSD data and the MTEX toolbox.
% ---------------------------------------------------------

% Close all figures, clear workspace, and command window
close all;
clear;
clc;

% Define crystal symmetry for Ni-superalloy
crystalSymmetry = {... 
    'notIndexed', ...
    crystalSymmetry('m-3m', [3.6 3.6 3.6], 'mineral', 'Ni-superalloy', 'color', [0.53 0.81 0.98])};

% Set plotting preferences: x-axis direction as east, z-axis as into the plane
setMTEXpref('xAxisDirection', 'east'); 
setMTEXpref('zAxisDirection', 'inOfPlane');

%% File paths and time points
inputDataPath = '.\data\p23_GNSNi_AGG_taichang_2024\excerpt_ctf\';

% Generate the full file path for each time point
inputFile = fullfile(inputDataPath, 'GNSNi_5min_taichang1_excerpt.ctf');

%% Load EBSD data from the specified file
ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                      'convertEuler2SpatialReferenceFrame');

% Process the EBSD data to identify and smooth grains
[grains, ebsdData] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);

% Define misorientation threshold for grain boundaries
deltaMisor = 5 * degree;

% Identify different types of grain boundaries
gB = grains.boundary('Ni-superalloy', 'Ni-superalloy');  % All boundaries
lAGB = gB(angle(gB.misorientation) < 15.0 * degree);     % Low-angle GBs (< 15°)
hAGB = gB(angle(gB.misorientation) >= 15.0 * degree);    % High-angle GBs (≥ 15°)

% Identify CSL boundaries with misorientation tolerance
gB3 = gB(gB.isTwinning(CSL(3, ebsdData.CS), deltaMisor)); % CSL Σ3 (twin boundaries)
gB5 = gB(gB.isTwinning(CSL(5, ebsdData.CS), deltaMisor)); % CSL Σ5
gB7 = gB(gB.isTwinning(CSL(7, ebsdData.CS), deltaMisor)); % CSL Σ7
gB9 = gB(gB.isTwinning(CSL(9, ebsdData.CS), deltaMisor)); % CSL Σ9
gB11 = gB(gB.isTwinning(CSL(11, ebsdData.CS), deltaMisor)); % CSL Σ11
gB15 = gB(gB.isTwinning(CSL(15, ebsdData.CS), deltaMisor)); % CSL Σ15

% Plot grain boundaries for the current time point
figure(iTime)
plot(hAGB, 'lineColor', 'black', 'linewidth', 0.5, 'micronbar', 'off'); % High-angle GBs
hold on

plot(lAGB, 'lineColor', 'Indigo', 'linewidth', 2, 'micronbar', 'off'); % Low-angle GBs
plot(gB3, 'lineColor', 'gold', 'linewidth', 2, 'DisplayName', 'CSL 3'); % Σ3 Twin boundaries
plot(gB5, 'lineColor', 'blue', 'linewidth', 2, 'DisplayName', 'CSL 5');
plot(gB7, 'lineColor', 'green', 'linewidth', 2, 'DisplayName', 'CSL 7');
plot(gB9, 'lineColor', 'magenta', 'linewidth', 2, 'DisplayName', 'CSL 9');
plot(gB11, 'lineColor', 'cyan', 'linewidth', 2, 'DisplayName', 'CSL 11');
plot(gB15, 'lineColor', 'orange', 'linewidth', 2, 'DisplayName', 'CSL 15');

% Disable the legend for simplicity
legend off

% End of script: E:\Github\MyRhinoLab\demo\mtex\mtex5_draw_gb_map.m
