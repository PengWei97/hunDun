% ---------------------------------------------------------
% Script Name: exp32_draw_kam_maps_for_excerpt.m
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

kam_lim = zeros(7, 2); % Initialize KAM limits

for iTime = 1:1 % length(timePoints)
    % Generate the full file path for each time point
    inputFile = fullfile(inputDataPath, sprintf('GNSNi_14min_local%d_excerpt_20241026.ctf', iTime));
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Initial grain calculation
    [grains, ebsdData.grainId, ebsdData.mis2mean] = calcGrains(ebsdData, 'threshold', 2 * degree);
    grains = smooth(grains, 10);

    % Convert EBSD data to grid and calculate KAM
    ebsdGrid = ebsdData.gridify;
    kam = ebsdGrid.KAM / degree; % Compute KAM in degrees

    % Store the min and max KAM values for each time point
    kam_lim(iTime, 1) = min(kam(:));
    kam_lim(iTime, 2) = max(kam(:));

    % Plot the KAM map for the current time point
    figure(iTime)
    plot(ebsdGrid, kam,'micronbar', 'off'); % Plot KAM with micronbar disabled
    mtexColorbar;                           % Add color bar
    set(gca, 'CLim', [0 4.0]);              % Set color limit to [0, 5] degrees
    mtexColorMap WhiteJet;                  % Set color map to 'WhiteJet' 
    
    % Optionally, you can overlay grain boundaries by uncommenting below:
    hold on
    plot(grains.boundary,'lineWidth',1.0)
    hold off  
end
