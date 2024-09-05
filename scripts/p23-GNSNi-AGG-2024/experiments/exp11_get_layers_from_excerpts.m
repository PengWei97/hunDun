% Clear all variables, close all figures, and clear command window
close all;
clear;
clc;

% Setup MTEX preferences for crystal symmetry and plotting conventions.
% Defines crystal symmetry for Nickel superalloy with specified lattice parameters and color for plotting.
crystalSymmetry = {...
  'notIndexed',...
  crystalSymmetry('m-3m', [3.6 3.6 3.6], 'mineral', 'Ni-superalloy', 'color', [0.53 0.81 0.98])};
setMTEXpref('xAxisDirection', 'west');  % Set the x-axis direction to west
setMTEXpref('zAxisDirection', 'outOfPlane');  % Set the z-axis direction out of plane

%% Specify File Names
% Define the paths for input data and output data
dataPath = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_ctf\';
outputDirCtf = '.\data\p23_GMSNi_AGG_2024\exp_data\layers_ctf\';
outputDirAng = '.\data\p23_GMSNi_AGG_2024\exp_data\layers_ang\';
timePoints = [5.0, 10.0, 20.0, 30.0];  % Define time points for analysis

% Loop through each time point to process EBSD data
for iTime = 2:2
    % Path to input file and Import the Data
    inputFile = fullfile(dataPath, sprintf('Ni_%dmin_excerpt.ctf', timePoints(iTime)));
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Process the EBSD data to identify and smooth grains
    [grains, ebsdData] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);

    % Plot the initial IPF map
    plotIPFMap(3*(iTime-1)+1, ebsdData, grains);

    % % Define region of interest within the EBSD data
    [xmin, xmax, ~, ~] = ebsdData.extend;
    ebsdLocal = ebsdData(inpolygon(ebsdData, [xmin, 15.0, xmin+335, 250.0-15.0])); % Layer13
    % % ebsdLocal = ebsdData(inpolygon(ebsdData, [510, 216.0, 810, 550.0-216.0])); % local-2
    % % ebsdLocal = ebsdData(inpolygon(ebsdData, [xmin, 216.0, xmax, 550.0-216.0])); % local-3
    % % ebsdLocal = ebsdData(inpolygon(ebsdData, [645.0, 218.0, 105, 105])); % local-4
    % % ebsdLocal = ebsdData(inpolygon(ebsdData, [xmin, 100.0, xmax, 300])); % local-5
    % ebsdLocal = ebsdData(inpolygon(ebsdData, [xmin, 15.0, xmax, 250.0-15.0])); % layer1
    % % ebsdLocal = ebsdData(inpolygon(ebsdData, [xmax-300, 0.0, xmax, 250.0])); % layer-1, local-1

    % Transform the mesh to increase resolution
    ebsdLocalMesh = transformMesh(ebsdLocal, 4.0);

    % Iterate through different smoothing parameters
    alphaValues = [0.0, 1.0];
    for iFill = 1:length(alphaValues)
      [grainsLocalMesh, ebsdLocalMesh] = identifyAndSmoothGrains(ebsdLocalMesh, 2.0 * degree, 60, 3.0);
      F = halfQuadraticFilter;
      F.alpha = alphaValues(iFill);
      ebsdLocalMesh = smooth(ebsdLocalMesh, F, 'fill', grainsLocalMesh);
      ebsdLocalMesh = ebsdLocalMesh('indexed');
    end

    % Final identification and smoothing of grains
    [grainsLocalMesh, ebsdLocalMesh] = identifyAndSmoothGrains(ebsdLocalMesh, 2.0 * degree, 60, 3.0);

    % Plot the second IPF map after further processing
    plotIPFMap(3*(iTime-1)+2, ebsdLocalMesh, grainsLocalMesh);

    % Reduce mesh resolution for final processing
    ebsdLocalMesh = transformMesh(ebsdLocalMesh, 1.0);
    [grainsLocalMesh, ebsdLocalMesh] = identifyAndSmoothGrains(ebsdLocalMesh, 2.0 * degree, 60, 3.0);
    plotIPFMap(3*(iTime-1)+3, ebsdLocalMesh, grainsLocalMesh);

    % Output processed data in CTF format
    outputFile = fullfile(outputDirCtf, sprintf('Ni_%dmin_layer13.ctf', timePoints(iTime)));
    export_ctf(ebsdLocalMesh, outputFile);

    % Output processed data in ANG format
    outputFile = fullfile(outputDirAng, sprintf('Ni_%dmin_layer13.ang', timePoints(iTime)));
    export_ang(ebsdLocalMesh, outputFile);
end

% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\experiments\exp11_get_layers_from_excerpts.m

% sum(grainsLocalMesh.grainSize) % 像素点
% grainsLocalMesh(11).grainSize
% [xmin, xmax, ymin, ymax] = ebsdLocalMesh.extend;
% grainArea = (ymax - ymin) * (xmax - xmin)
% sum(grainsLocalMesh.grainSize) 