% ---------------------------------------------------------
% Script Name: mtex3_draw_GND_map.m
% Created by: Peng Wei
% Date: October 17, 2024
% Purpose: To visualize GND maps of GNSNi samples using 
%          Taichang's EBSD data and the MTEX toolbox.
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

% Generate the full file path for the time point
inputFile = fullfile(inputDataPath, 'GNSNi_5min_taichang1_excerpt.ctf');

%% Load EBSD data from the specified file
ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                      'convertEuler2SpatialReferenceFrame');

% Calculate GND map
ebsdGrid = ebsdData('indexed').gridify;
rho = calculatedFCCGNDs(ebsdGrid);

% Draw GNDs map
[grainsData, ~] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);
plotGNDsMap(1, ebsdGrid, grainsData, rho);

% End of script: E:\Github\MyRhinoLab\demo\mtex\mtex3_draw_GND_map.m
