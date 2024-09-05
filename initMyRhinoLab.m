% initMyRhinoLab.m
% Initialization script for the RhinoLab repository

% Clear environment (optional, based on preference)
clear;
clc;
close all;

% initial MTEX-5.8.1
run('..\mtex-5.8.1\startup_mtex.m')

% Define the base directory for the repository
baseDir = fileparts(mfilename('fullpath'));  % Gets the directory of the current script

% Add necessary paths for src
addpath(fullfile(baseDir, 'src', 'postprocessing'));
addpath(fullfile(baseDir, 'src', 'io'));
addpath(fullfile(baseDir, 'src', 'figures'));
addpath(fullfile(baseDir, 'src', 'mtex'));

% 
addpath(fullfile(baseDir, 'scripts', 'p23-GNSNi-AGG-2024', 'simulations'));
addpath(fullfile(baseDir, 'scripts', 'p23-GNSNi-AGG-2024', 'experiments'));
addpath(fullfile(baseDir, 'scripts', 'p22-Ti-withOrWithout-twins-2024', 'simulations'));
addpath(fullfile(baseDir, 'scripts', 'p22-Ti-withOrWithout-twins-2024', 'experiments'));

% Display a message confirming initialization is complete
disp('RhinoLab environment initialized.');