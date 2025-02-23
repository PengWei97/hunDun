% ---------------------------------------------------------
% Script Name: exp31_draw_gb_maps_for_excerpt.m
% Created by: Peng Wei
% Date: October 27, 2024
% Purpose: To visualize grain boundary (GB) maps of GNSNi samples at different 
%          time points using taichang's EBSD data and MTEX toolbox. The script 
%          identifies high-angle grain boundaries (HAGB), low-angle grain boundaries 
%          (LAGB), and several Coincidence Site Lattice (CSL) boundaries.
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

for iTime = 4:4 % length(timePoints)
    % Generate the full file path for each time point
    inputFile = fullfile(inputDataPath, sprintf('GNSNi_14min_local%d-2_excerpt_20241026.ctf', iTime));
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Transform the mesh to increase resolution
    ebsdDataMesh = transformMesh(ebsdData, 4.0);

    % Iterate through different smoothing parameters
    alphaValues = [0.0, 1.0];
    for iFill = 1:length(alphaValues)
      [grainsDataMesh, ebsdDataMesh] = identifyAndSmoothGrains(ebsdDataMesh, 2.0 * degree, 60, 3.0);
      F = halfQuadraticFilter;
      F.alpha = alphaValues(iFill);
      ebsdDataMesh = smooth(ebsdDataMesh, F, 'fill', grainsDataMesh);
      ebsdDataMesh = ebsdDataMesh('indexed');
    end

    % Final identification and smoothing of grains
    [grainsDataMesh, ebsdDataMesh] = identifyAndSmoothGrains(ebsdDataMesh, 2.0 * degree, 60, 3.0);

    % Plot the second IPF map after further processing
    plotIPFMap(1, ebsdDataMesh, grainsDataMesh);

   % Define misorientation threshold for grain boundaries
   deltaMisor = 5 * degree;

   % Identify different types of grain boundaries
   gB = grainsDataMesh.boundary('Ni-superalloy', 'Ni-superalloy');  % All boundaries
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
   plot(hAGB, 'lineColor', 'black', 'linewidth', 1.5, 'micronbar', 'off'); % High-angle GBs
   hold on

   plot(lAGB, 'lineColor', 'Indigo', 'linewidth', 2, 'micronbar', 'off'); % Low-angle GBs
   plot(gB3, 'lineColor', 'gold', 'linewidth', 2, 'DisplayName', 'CSL 3'); % Σ3 Twin boundaries
   % plot(gB5, 'lineColor', 'blue', 'linewidth', 2, 'DisplayName', 'CSL 5');
   % plot(gB7, 'lineColor', 'green', 'linewidth', 2, 'DisplayName', 'CSL 7');
   plot(gB9, 'lineColor', 'magenta', 'linewidth', 2, 'DisplayName', 'CSL 9');
   % plot(gB11, 'lineColor', 'cyan', 'linewidth', 2, 'DisplayName', 'CSL 11');
   % plot(gB15, 'lineColor', 'orange', 'linewidth', 2, 'DisplayName', 'CSL 15');

   % Disable the legend for simplicity
   legend off
end

% End of script
