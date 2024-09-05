
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
dataPath = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_ctf_local\';
outputDir = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_ctf_local\';
timePoints = [5.0, 10.0, 20.0, 30.0];  % Define time points for analysis

numTypeFigures = 2;
% Loop through each time point to process EBSD data
for iTime = 2:2
    % Path to input file and Import the Data
    inputFile = fullfile(dataPath, sprintf('Ni_%dmin_local5.ctf', timePoints(iTime)));
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Process the EBSD data to identify and smooth grains
    [grains, ebsdData] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);

    % Plot the initial IPF map
    % plotIPFMap(3*(iTime-1)+1, ebsdData, grains);

    plotMeanIPFMap(numTypeFigures*(iTime-1)+1, grains);

    deltaMisor = 5*degree;
    gB = grains.boundary('Ni-superalloy', 'Ni-superalloy');
    lAGB = gB(angle(gB.misorientation) < 15.0 * degree);
    hAGB = gB(angle(gB.misorientation) >= 15.0 * degree);
    gB3 = gB(gB.isTwinning(CSL(3, ebsdData.CS), deltaMisor));
    gB5 = gB(gB.isTwinning(CSL(5,ebsdData.CS), deltaMisor));
    gB7 = gB(gB.isTwinning(CSL(7,ebsdData.CS), deltaMisor));
    gB9 = gB(gB.isTwinning(CSL(9,ebsdData.CS), deltaMisor));
    gB11 = gB(gB.isTwinning(CSL(11,ebsdData.CS), deltaMisor));
    gB15 = gB(gB.isTwinning(CSL(15,ebsdData.CS), deltaMisor));
    
    idFigure = numTypeFigures*(iTime-1)+2;
    figure(idFigure)
    plot(hAGB, 'lineColor', 'black', 'linewidth', 0.5, 'micronbar', 'off')
    hold on

    plot(lAGB, 'lineColor', 'Indigo', 'linewidth', 2, 'micronbar', 'off')
    plot(gB3, 'lineColor', 'gold', 'linewidth', 2, 'DisplayName', 'CSL 3');
    plot(gB5, 'lineColor', 'blue', 'linewidth', 2, 'DisplayName', 'CSL 5');
    plot(gB7, 'lineColor', 'green', 'linewidth', 2, 'DisplayName', 'CSL 7');
    plot(gB9, 'lineColor', 'magenta', 'linewidth', 2, 'DisplayName', 'CSL 9');
    plot(gB11, 'lineColor', 'cyan', 'linewidth', 2, 'DisplayName', 'CSL 11');
    plot(gB15, 'lineColor', 'orange', 'linewidth', 2, 'DisplayName', 'CSL 15');
    
end

% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\experiments\exp14_draw_gb_maps_for_locals.m