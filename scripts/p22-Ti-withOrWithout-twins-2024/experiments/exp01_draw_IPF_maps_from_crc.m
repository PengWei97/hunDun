close all
clear all
clc

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/mmm', [3 3 4.7], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Ti-Hex', 'color', [0.53 0.81 0.98])};

% plotting convention
setMTEXpref('xAxisDirection','north'); 
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = '.\data\p22_Ti_withOrWithout_twins\exp_data\crc';
outputDirCtf = '.\data\p22_Ti_withOrWithout_twins\exp_data\excerpt_ctf\';

% which files to be imported
% fname = [pname '\Ti_with_twins_v2.crc'];
fname = [pname '\Ti_without_twins_v2.crc'];

%% Import the Data
timePoints = [0, 10, 15, 30, 60];
for iTime = 1:1 %length(timePoints)
  % create an EBSD variable containing the data
  ebsdData = EBSD.load(fname,CS,'interface','crc',...
    'convertSpatial2EulerReferenceFrame'); % convertSpatial2EulerReferenceFrame convertEuler2SpatialReferenceFrame

  [grains, ebsdData] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);
  % rot=rotation('Euler', 0*degree, 90*degree, 0*degree);
  % ebsdData=rotate(ebsdData,rot,'keepXY');
  % plot(ebsdData, ebsdData.orientations)
  idFigure = 1;
  plotIPFMap(idFigure, ebsdData, grains);

  % Output processed data in CTF format
  outputFile = fullfile(outputDirCtf, sprintf('Ti_without_twins_%dmins_excerpt2.ctf', timePoints(iTime)));
  export_ctf(ebsdData, outputFile);
end
% E:\Github\MyRhinoLab\scripts\p22-Ti-withOrWithout-twins-2024\experiments\exp01_draw_IPF_maps_from_crc.m