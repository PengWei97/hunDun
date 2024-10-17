% initMyRhinoLab.m
% Initialization script for the RhinoLab repository

% Clear environment (optional, based on preference)
clear;
clc;
close all;

% initial MTEX-5.8.1
run('..\mtex-5.8.1\startup_mtex.m')

% Define the base directory for the repository
baseDir = fileparts(mfilename('fullpath'));  % Gets the directory of
addpath(genpath(baseDir));

% Display a message confirming initialization is complete
disp('RhinoLab environment initialized.');