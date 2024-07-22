% initMyRhinoLab.m
% Initialization script for the RhinoLab repository

% Clear environment (optional, based on preference)
clear;
clc;
close all;

% Define the base directory for the repository
baseDir = fileparts(mfilename('fullpath'));  % Gets the directory of the current script

% Add necessary paths for src
addpath(fullfile(baseDir, 'src', 'postprocessing'));
addpath(fullfile(baseDir, 'src', 'io'));
addpath(fullfile(baseDir, 'src', 'figures'));

% 
addpath(fullfile(baseDir, 'scripts', 'p23-GNSNi-AGG-2024', 'simulations'));

% Display a message confirming initialization is complete
disp('RhinoLab environment initialized.');
