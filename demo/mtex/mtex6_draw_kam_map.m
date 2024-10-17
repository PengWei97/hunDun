% ---------------------------------------------------------
% Script Name: mtex5_draw_kam_map.m
% Created by: Peng Wei
% Date: October 17, 2024
% Purpose: To visualize KAM maps of GNSNi samples 
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

kam_lim = zeros(length(timePoints), 2); % Initialize limits for KAM

% Convert EBSD data to grid and calculate KAM
ebsdGrid = ebsdData.gridify; % Gridify the EBSD data
kam = ebsdGrid.KAM / degree;  % Compute KAM in degrees

% Store the min and max KAM values for each time point
kam_lim(iTime, 1) = min(kam(:)); % Minimum KAM value
kam_lim(iTime, 2) = max(kam(:)); % Maximum KAM value

% Plot the KAM map for the current time point
figure(iTime)
plot(ebsdGrid, kam, 'micronbar', 'off'); % Plot KAM without micronbar
mtexColorbar;                           % Add color bar
set(gca, 'CLim', [0 5.0]);              % Set color limit to [0, 5] degrees
mtexColorMap WhiteJet;                  % Set color map to 'WhiteJet'

% End of script: E:\Github\MyRhinoLab\demo\mtex\mtex5_draw_kam_map.m
