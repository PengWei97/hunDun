% ---------------------------------------------------------
% Script Name: a_calculate_mp
% Created by: Peng Wei and Xie Yu
% Date: October 27, 2024
% Purpose: 为了计算m'
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
dataPath = 'H:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\d1_GNSNi_QIS_EBSD_12minTo\ctf_initial\';
inputFile = fullfile(dataPath, 'GNSNi_12min_R2.ctf'); % for 106 for 14mins
ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
  'convertSpatial2EulerReferenceFrame'); % convertSpatial2EulerReferenceFrame convertEuler2SpatialReferenceFrame

figure(1)
plot(ebsdData, ebsdData.orientations, 'coordinates', 'off', 'micronbar', 'on');

% ebsdData = ebsdData(inpolygon(ebsdData, [-100, 200, 100, 100]));

% draw grains ipf map
[grains, ebsdData.grainId] = calcGrains(ebsdData, 'degree', 15*degree);
ebsdData(grains(grains.diameter < 5)) = [];
[grains, ebsdData.grainId] = calcGrains(ebsdData, 'degree', 15*degree);
grains = smooth(grains, 5);

gB = grains.boundary('indexed');
figure(2)
plot(grains, grains.meanOrientation, 'microbar', 'on', 'linewidth', 1);

% calculate m
oris = grains.meanOrientation;
sS = symmetrise(slipSystem.fcc(ebsdData.CS), 'antipodal');
sSo = oris*sS; % rotate slip system
min_ang = angle(sSo(:,:).n,sSo(:,:).n); % smallest angle between slip planes
[alpha, ~] = min(min_ang, [], 2);
sSoS = sSo(:, min_ang - alpha <= 1e-7);
beta = min(angle(sSoS(1,:).b,sSoS(2,:).b));
m = cos(alpha)*cos(beta);

% H:\Github\MyRhinoLab\demo\plasticty\a_calculate_mp.m