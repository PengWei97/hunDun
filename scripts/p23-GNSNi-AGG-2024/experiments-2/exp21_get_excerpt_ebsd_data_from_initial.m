% ---------------------------------------------------------
% Script Name: exp21_get_excerpt_ebsd_data_from_initial.m
% Created by: Peng Wei
% Date: October 17, 2024
% Purpose: To extract and export specific regions of EBSD data (GNSNi samples)
%          from different time points using taichang's dataset for further analysis.
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
inputDataPath = '.\data\p23_GNSNi_AGG_taichang_2024\initial_ctf\';  % Input directory
outputDataPath = '.\data\p23_GNSNi_AGG_taichang_2024\excerpt_ctf\'; % Output directory
timePoints = [5.0, 10.0, 12.0, 14.0, 17.0, 20.0, 25.0, 30.0]; % Time points to process

% Box dimensions (center coordinates) for different regions to extract
boxSizes = [0,0; 32.8,34.6; 72.6,36.0; 29.5,39.0; 54.6,67.2; 57.9,56.3; 21.9,34.5; 21.9,22.7];
boxSizesWidth = 1000; % Width of the region to extract
boxSizesHigh = 470;   % Height of the region to extract

% Loop over each time point to load, extract, and export the corresponding EBSD data
for iTime = 1:length(timePoints)
    % Generate the full file path for each time point
    inputFile = fullfile(inputDataPath, sprintf('GNSNi_%dmin_taichang_1.ctf', timePoints(iTime)));
    
    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');
    
    % Extract a sub-region of the EBSD data based on predefined box dimensions
    ebsdDataExcerpt = ebsdData(inpolygon(ebsdData, [boxSizes(iTime, 1), boxSizes(iTime, 2),  boxSizesWidth, boxSizesHigh]));

    % Specify the output CTF file path for exporting
    outputFile = fullfile(outputDataPath, sprintf('GNSNi_%dmin_taichang1_excerpt.ctf', timePoints(iTime)));

    % Export the extracted EBSD data to CTF format
    export_ctf(ebsdDataExcerpt, outputFile);    
end
