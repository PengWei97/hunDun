
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
dataPath = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_ctf_regions\';
outputDir = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_ctf_regions\';
timePoints = [5.0, 10.0, 20.0, 30.0];  % Define time points for analysis

% Loop through each time point to process EBSD data
for iRegion = 1:1
  for iTime = 2:2
      % Path to input file and Import the Data
      inputFile = fullfile(dataPath, sprintf('Ni_%dmin_region%d.ctf', timePoints(iTime), iRegion));
      ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                          'convertEuler2SpatialReferenceFrame');

      % Process the EBSD data to identify and smooth grains
      [grains, ebsdData] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);

      % Plot the initial IPF map
      % plotIPFMap(3*(iTime-1)+1, ebsdData, grains);

      plotMeanIPFMap(3*(iTime-1)+1, grains);

      % calculated GND map
      ebsdGrid = ebsdData('indexed').gridify;
      rho = calculatedFCCGNDs(ebsdGrid);
      
      % draw GNDs map
      % [grainsGrid, ebsdGrid] = identifyAndSmoothGrains(ebsdGrid, 2.0 * degree, 10, 3.0);
      plotGNDsMap(3*(iTime-1)+2, ebsdGrid, grains, rho);

      % output ctf data containing rho
      outputFile = fullfile(outputDir, sprintf('Ni_%dmin_region%d_rho.ctf', timePoints(iTime), iRegion));
      export_ctf(ebsdGrid, rho, outputFile);
  end
end
% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\experiments\exp33_calcu_GNS_map_and_ctf.m

% plotGNDsMap(3*(iTime-1)+2, ebsdGrid, grainsGrid, rho_1);

% ori1 = grains(92).meanOrientation;
% ori2 = grains(169).meanOrientation;
% angle(ori1, ori2) ./ degree