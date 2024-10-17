% ---------------------------------------------------------
% Script Name: exp24_draw_GND_maps_and_save_figs_for_excerpt.m
% Created by: Peng Wei
% Date: October 17, 2024
% Purpose: To calculate and visualize GND maps of GNSNi samples 
%          at different time points using EBSD data and save 
%          the figures in .fig format.
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
outputDataPath = '.\data\p23_GNSNi_AGG_taichang_2024\excerpt_GNDMap_fig\'; % Path to save the figures
timePoints = [5.0, 10.0, 12.0, 14.0, 17.0, 20.0, 25.0, 30.0]; % Time points of the samples

rho_lim = zeros(length(timePoints), 2); % Initialize GND limits

% Loop over each time point to load and process the corresponding EBSD data
for iTime = 5:length(timePoints)
    % Generate the full file path for each time point
    inputFile = fullfile(inputDataPath, sprintf('GNSNi_%dmin_taichang1_excerpt.ctf', timePoints(iTime)));
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Calculate GND map from the EBSD data
    ebsdGrid = ebsdData('indexed').gridify;
    rho = calculatedFCCGNDs(ebsdGrid); % Function to calculate GND density

    % Store the min and max GND values for later use
    rho_lim(iTime, 1) = min(rho);
    rho_lim(iTime, 2) = max(rho);

    % Draw GNDs map
    [grainsData, ~] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0); % Grain identification
    plotGNDsMap(iTime, ebsdGrid, grainsData, rho); % Function to plot the GND map

    % Specify the output .fig file path for exporting
    outputFile = fullfile(outputDataPath, sprintf('GNSNi_%dmin_taichang1_GND_excerpt.fig', timePoints(iTime)));

    % Save the figure in .fig format
    savefig(outputFile);
end
