% ---------------------------------------------------------
% Script Name: mtex2_draw_ipf_map.m
% Created by: Peng Wei
% Date: October 17, 2024
% Purpose: A demo to visualize the IPF map of GNSNi samples 
%          using EBSD data and the MTEX toolbox.
% ---------------------------------------------------------

% Close all figures, clear command window and workspace
close all;
clc;
clear;

% Define the input and output data paths
input_data_path = '.\data\p23_GNSNi_AGG_taichang_2024\initial_ctf\';
output_data_path = input_data_path;

% Define crystal symmetry for the EBSD data
crystal_symmetry = {...  
    'notIndexed', ...  % First entry represents non-indexed phases
    crystalSymmetry('m-3m', [3.6, 3.6, 3.6], ...  % Crystal symmetry for Ni-superalloy
                    'mineral', 'Ni-superalloy', ...
                    'color', [0.53, 0.81, 0.98])};  % Color for plotting Ni-superalloy

% Set plotting preferences (MTEX settings)
setMTEXpref('xAxisDirection', 'west');  % Define x-axis direction as west
setMTEXpref('zAxisDirection', 'outOfPlane');  % Define z-axis direction as out-of-plane

% Specify the input CRC file for EBSD data
input_file = fullfile(input_data_path, 'GNSNi_10min_taichang_1.crc');

%% Import the EBSD Data
% Load EBSD data from CRC file using specified crystal symmetry
ebsd_data = EBSD.load(input_file, crystal_symmetry, 'interface', 'crc', ...
                      'convertEuler2SpatialReferenceFrame');

% Plot the EBSD data with orientations, no coordinates or micron bar
plot(ebsd_data, ebsd_data.orientations, 'coordinates', 'off', 'micronbar', 'off');
