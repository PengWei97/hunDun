% ---------------------------------------------------------
% Script Name: exp4a0_draw_IPF_maps_for_initial.m
% Created by: Peng Wei
% Date: October 27, 2024
% Purpose: To visualize IPF maps of GNSNi samples at different time points 
%          using taichang's EBSD data and MTEX toolbox.
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
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','inOfPlane');

%% File paths and time points
dataPath = '.\data\p23_GNSNi_AGG_2024\ebsd\c1_GNSNi_QIS_EBSD_106_202411\ctf_initial\';
chosenTimes = [5 10 12 14 17 20 30];

% Loop over each time point to load and plot the corresponding EBSD data
for iTime = 1:1 % length(timePoints)
    % Generate the full file path for each time point
    % inputFile = fullfile(dataPath, sprintf('GNSNi_%dmin_taichang_2.ctf', timePoints(iTime))); % for taichang quasi-in-situ EBSD
    inputFile = fullfile(dataPath, sprintf('GNSNi-%dmin-region2p1-20241103.ctf', chosenTimes(iTime))); % for 106 for 14mins
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertSpatial2EulerReferenceFrame'); % convertSpatial2EulerReferenceFrame convertEuler2SpatialReferenceFrame

    % Create a new figure for each time point
    figure(1);
    plot(ebsdData, ebsdData.orientations, 'coordinates', 'on', 'micronbar', 'off');

    % % Initial grain calculation
    % [grainsData, ebsdData.grainId, ebsdData.mis2mean] = calcGrains(ebsdData, 'threshold', 2 * degree);

    % % Smooth the grains
    % grainsData = smooth(grainsData, 10);

    % % Create a new figure for each time point
    % plotIPFMap(2, ebsdData, grainsData);    
end
