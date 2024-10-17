% ---------------------------------------------------------
% Script Name: exp25_draw_PF_maps_for_excerpt.m
% Created by: Peng Wei
% Date: October 17, 2024
% Purpose: To visualize pole figure (PF) maps of GNSNi samples at different time points 
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
inputDataPath = '.\data\p23_GNSNi_AGG_taichang_2024\excerpt_ctf\'; % Path to EBSD data
timePoints = [5.0, 10.0, 12.0, 14.0, 17.0, 20.0, 25.0, 30.0]; % Time points to plot

% Loop over each time point to load and plot the corresponding EBSD data
for iTime = 1:length(timePoints)
    % Generate the full file path for each time point
    inputFile = fullfile(inputDataPath, sprintf('GNSNi_%dmin_taichang1_excerpt.ctf', timePoints(iTime)));
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Extract the orientations for Ni-superalloy phase
    cs = crystalSymmetry{2}; % Get crystal symmetry for Ni-superalloy
    ori = ebsdData('Ni-superalloy').orientations; % Get the orientations

    % Plot the Pole Figure (PF) for the selected orientations
    figure(iTime)
    plotPDF(ori, Miller({1,1,1},{1,0,0}, cs), 'contourf'); % Plot {111} and {100} PFs

    % Set the figure and axes properties for exporting with a transparent background
    set(gcf, 'Unit', 'centimeters', 'Color', 'None');
    set(gca, 'Color', 'None'); % Set axes background color to transparent
    
    % Add color bar for clarity
    mtexColorbar;
end
