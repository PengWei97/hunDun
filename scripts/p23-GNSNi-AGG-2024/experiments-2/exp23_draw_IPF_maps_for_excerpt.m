% ---------------------------------------------------------
% Script Name: exp23_draw_IPF_maps_for_excerpt.m
% Created by: Peng Wei
% Date: October 17, 2024
% Purpose: To visualize IPF maps of GNSNi samples at different time points 
%          using taichang's EBSD data (excerpt data) and the MTEX toolbox.
% ---------------------------------------------------------

% Close all figures, clear workspace, and clear command window
close all;
clear;
clc;

% Define the crystal symmetry for the Ni-superalloy
crystalSymmetry = {... 
    'notIndexed', ...
    crystalSymmetry('m-3m', [3.6 3.6 3.6], 'mineral', 'Ni-superalloy', 'color', [0.53 0.81 0.98])};

% Set MTEX plotting preferences: x-axis direction as east, z-axis into the plane
setMTEXpref('xAxisDirection', 'east'); 
setMTEXpref('zAxisDirection', 'inOfPlane');

%% File paths and time points
inputDataPath = '.\data\p23_GNSNi_AGG_taichang_2024\excerpt_ctf\'; % Path to the data
timePoints = [5.0, 10.0, 12.0, 14.0, 17.0, 20.0, 25.0, 30.0];      % Time points of the samples

% Loop over each time point to load and visualize the corresponding EBSD data
for iTime = 2:length(timePoints)
    % Generate the full file path for each time point
    inputFile = fullfile(inputDataPath, sprintf('GNSNi_%dmin_taichang1_excerpt.ctf', timePoints(iTime)));
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Create a new figure for each time point
    figure(iTime);
    
    % Plot the EBSD orientation data without coordinates and micron bar
    plot(ebsdData, ebsdData.orientations, 'coordinates', 'off', 'micronbar', 'off');
end
