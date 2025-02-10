% ---------------------------------------------------------
% Script Name: exp30_draw_IPF_maps_for_initial.m
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
dataPath = '.\data\p23_GNS_AGG_106_20241026\ctf_initial_14mins\';
outputDataPath = '.\data\p23_GNS_AGG_106_20241026\ctf_excerpt_14mins\'; % Output directory

% Loop over each time point to load and plot the corresponding EBSD data
for iTime = 4:4 % length(timePoints)
    % Generate the full file path for each time point
    % inputFile = fullfile(dataPath, sprintf('GNSNi_%dmin_taichang_2.ctf', timePoints(iTime))); % for taichang quasi-in-situ EBSD
    inputFile = fullfile(dataPath, sprintf('GNSNi_14min_20241026_local%d-2.ctf', iTime)); % for 106 for 14mins
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertSpatial2EulerReferenceFrame'); % convertSpatial2EulerReferenceFrame convertEuler2SpatialReferenceFrame

    [xmin, xmax, ymin, ymax] = ebsdData.extend(); % get the range of the EBSD data
    ebsdData = ebsdData(inpolygon(ebsdData, [xmin, ymin, xmax-xmin, -38-ymin])); % crop the EBSD data to the region of interest
    
    % Create a new figure for each time point
    figure(3*(iTime-1)+1);
    plot(ebsdData, ebsdData.orientations, 'coordinates', 'on', 'micronbar', 'off');

    % Initial grain calculation
    [grainsData, ebsdData.grainId, ebsdData.mis2mean] = calcGrains(ebsdData, 'threshold', 2 * degree);

    % Smooth the grains
    grainsData = smooth(grainsData, 10);

    % Create a new figure for each time point
    plotIPFMap(3*(iTime-1)+2, ebsdData, grainsData);

    % filling ebsd data
    ebsdMesh = transformMesh(ebsdData, 2.0);
    F = halfQuadraticFilter;
    F.alpha = 0;
    ebsdMesh = smooth(ebsdMesh, F, 'fill', grainsData);
    plotIPFMap(3*(iTime-1)+3, ebsdMesh, grainsData);

    % Specify the output CTF file path for exporting
    outputFile = fullfile(outputDataPath, sprintf('GNSNi_14min_local%d-2_excerpt_20241026.ctf', iTime));
    export_ctf(ebsdMesh, outputFile);        
end
