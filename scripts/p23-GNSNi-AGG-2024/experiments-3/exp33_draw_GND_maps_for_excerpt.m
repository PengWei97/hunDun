% ---------------------------------------------------------
% Script Name: exp33_draw_GND_maps_for_excerpt.m
% Created by: Peng Wei
% Date: October 17, 2024
% Purpose: To visualize KAM maps of GNSNi samples at different time points 
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
inputDataPath = '.\data\p23_GNS_AGG_106_20241026\ctf_excerpt_14mins\';
outputDataPath = '.\data\p23_GNS_AGG_106_20241026\fig_excerpt_14mins_GNDMap\'; % Path to save the figures

rho_lim = zeros(7, 2); % Initialize KAM limits

for iTime = 3:3 % length(timePoints)
    % Generate the full file path for each time point
    inputFile = fullfile(inputDataPath, sprintf('GNSNi_14min_local%d_excerpt_20241026.ctf', iTime));
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Calculate GND map from the EBSD data
    ebsdGrid = ebsdData('indexed').gridify;
    rho = calculatedFCCGNDs(ebsdGrid); % Function to calculate GND density

    % Store the min and max GND values for later use
    rho_lim(iTime, 1) = min(rho);
    rho_lim(iTime, 2) = max(rho);

    % Initial grain calculation
    [grains, ebsdData.grainId, ebsdData.mis2mean] = calcGrains(ebsdData, 'threshold', 2 * degree);
    grains = smooth(grains, 10);

    plotGNDsMap(iTime, ebsdGrid, grains, rho); % Function to plot the GND map

    % Specify the output .fig file path for exporting
    outputFile = fullfile(outputDataPath, sprintf('GNSNi_%dmin_taichang1_GND_excerpt.fig', iTime));

    % Save the figure in .fig format
    savefig(outputFile);
end
