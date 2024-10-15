close all;
clear;
clc;

% Define crystal symmetry
crystalSymmetry = {...
  'notIndexed',...
  crystalSymmetry('m-3m', [3.6 3.6 3.6], 'mineral', 'Ni-superalloy', 'color', [0.53 0.81 0.98])};

% Set plotting convention
setMTEXpref('xAxisDirection', 'west');
setMTEXpref('zAxisDirection', 'outOfPlane');

%% Specify File Names
dataPath = 'D:\Github\MyRhinoLab\data\p23_GNSNi_AGG_2024\';
timePoints = [5.0, 10.0, 12.0, 14.0, 17.0, 20.0, 25.0, 30.0];
numTypeFigures = 2;

for iTime = 2:2 % 3:length(timePoints)
    % % Path to files
    % inputFile = fullfile(dataPath, sprintf('GNSNi_%dmin_taichang_1.ctf', timePoints(iTime)));
    
    % %% Import the Data
    % ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
    %                      'convertEuler2SpatialReferenceFrame');

    % Path to files
    inputFile = fullfile(dataPath, sprintf('GNSNi_%dmin_taichang_1.crc', timePoints(iTime)));
    
    %% Import the Data
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'crc', ...
                         'convertEuler2SpatialReferenceFrame');

    % [grains, ebsdData] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);
    
    idFigure = numTypeFigures*(iTime-1)+1;

    figure(iTime);
    plot(ebsdData, ebsdData.orientations, 'coordinates', 'off', 'micronbar', 'off');
end

% D:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\experiments-2\exp202_draw_IPF_maps_for_excerpts.m