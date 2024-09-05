
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
dataPath = '.\data\p23_GMSNi_AGG_2024\exp_data\layers_ctf\';
outputDir = '.\data\p23_GMSNi_AGG_2024\exp_data\layers_ctf_rho\';
timePoints = [5.0, 10.0, 20.0, 30.0];  % Define time points for analysis

% Loop through each time point to process EBSD data
for iTime = 3:3
    % Path to input file and Import the Data
    inputFile = fullfile(dataPath, sprintf('Ni_%dmin_layer1.ctf', timePoints(iTime)));
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertEuler2SpatialReferenceFrame');

    % Process the EBSD data to identify and smooth grains
    [grains, ebsdData] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);

    % Plot the initial IPF map
    plotIPFMap(3*(iTime-1)+1, ebsdData, grains);

    plotMeanIPFMap(3*(iTime-1)+1, grains);

    plotFCCGBMap(5*degree, grains, 3*(iTime-1)+2, ebsdData);

    % % calculated GND map
    % ebsdGrid = ebsdData('indexed').gridify;
    % rho = calculatedFCCGNDs(ebsdGrid);
    
    % % draw GNDs map
    % % [grainsGrid, ebsdGrid] = identifyAndSmoothGrains(ebsdGrid, 2.0 * degree, 10, 3.0);
    % plotGNDsMap(3*(iTime-1)+2, ebsdGrid, grains, rho);

    % % output ctf data containing rho
    % outputFile = fullfile(outputDir, sprintf('Ni_%dmin_level1_local1_rho.ctf', timePoints(iTime)));
    % export_ctf(ebsdGrid, rho, outputFile);
end
% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\experiments\exp12_calculate_GNS_map_and_ctf.m

function plotFCCGBMap(deltaMisor, grains, iFigure, ebsd)
    gB = grains.boundary('Ni-superalloy', 'Ni-superalloy');
    lAGB = gB(angle(gB.misorientation) < 15.0 * degree);
    hAGB = gB(angle(gB.misorientation) >= 15.0 * degree);
    gB3 = gB(gB.isTwinning(CSL(3, ebsd.CS), deltaMisor));
    gB5 = gB(gB.isTwinning(CSL(5,ebsd.CS), deltaMisor));
    gB7 = gB(gB.isTwinning(CSL(7,ebsd.CS), deltaMisor));
    gB9 = gB(gB.isTwinning(CSL(9,ebsd.CS), deltaMisor));
    gB11 = gB(gB.isTwinning(CSL(11,ebsd.CS), deltaMisor));
    gB15 = gB(gB.isTwinning(CSL(15,ebsd.CS), deltaMisor));
    
    figure(iFigure)
    plot(hAGB, 'lineColor', 'black', 'linewidth', 0.5, 'DisplayName', 'HAGB')
    hold on

    plot(lAGB, 'lineColor', 'Indigo', 'linewidth', 2, 'DisplayName', 'LAGB')
    plot(gB3, 'lineColor', 'gold', 'linewidth', 2, 'DisplayName', 'CSL 3');
    plot(gB5, 'lineColor', 'blue', 'linewidth', 2, 'DisplayName', 'CSL 5');
    plot(gB7, 'lineColor', 'green', 'linewidth', 2, 'DisplayName', 'CSL 7');
    plot(gB9, 'lineColor', 'magenta', 'linewidth', 2, 'DisplayName', 'CSL 9');
    plot(gB11, 'lineColor', 'cyan', 'linewidth', 2, 'DisplayName', 'CSL 11');
    plot(gB15, 'lineColor', 'orange', 'linewidth', 2, 'DisplayName', 'CSL 15');

    % gb length
    gB_length = sum(segLength(gB));

    lAGB_length = sum(segLength(lAGB))./gB_length;
    hAGB_length = sum(segLength(hAGB))./gB_length;
    gB3_length = sum(segLength(gB3))./gB_length;
    gB5_length = sum(segLength(gB5))./gB_length;
    gB7_length = sum(segLength(gB7))./gB_length;
    gB9_length = sum(segLength(gB9))./gB_length;
    gB11_length = sum(segLength(gB11))./gB_length;
    gB15_length = sum(segLength(gB15))./gB_length;

    gbs_length = [lAGB_length, hAGB_length, gB3_length, gB5_length, gB7_length, gB9_length, gB11_length, gB15_length];
    0.0159    0.9841    0.4194    0.0004    0.0040    0.0282    0.0032    0.0036
    gbs_length
end
% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\experiments\exp12_calculate_GNS_map_and_ctf.m