% ---------------------------------------------------------
% Script Name: exp20_draw_IPF_maps_for_initial.m
% Created by: Peng Wei
% Date: October 16, 2024
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
setMTEXpref('xAxisDirection', 'east'); 
setMTEXpref('zAxisDirection', 'inOfPlane');

%% File paths and time points
dataPath = '.\data\p23_GNSNi_AGG_taichang_2024\initial_ctf\';
timePoints = [5.0, 10.0, 12.0, 14.0, 17.0, 20.0, 25.0, 30.0]; % Time points to plot

% Loop over each time point to load and plot the corresponding EBSD data
for iTime = 1:length(timePoints)
    % Generate the full file path for each time point
    inputFile = fullfile(dataPath, sprintf('GNSNi_%dmin_taichang_1.ctf', timePoints(iTime)));
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Create a new figure for each time point
    figure(iTime);
    % Plot the EBSD orientation data with coordinates on and micron bar off
    plot(ebsdData, ebsdData.orientations, 'coordinates', 'on', 'micronbar', 'off');
end
