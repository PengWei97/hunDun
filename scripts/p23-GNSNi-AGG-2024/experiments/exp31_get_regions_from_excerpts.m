% Clear all variables, close all figures, and clear command window
close all;
clear;
clc;

boxSizes = [866.7500  135.5600  130  130;
            761.4200  184.8900   66   61;
            446.7000  165.4700  130   90;
            222.0800  162.6500  155   100;
            53.3000  187.8000   60   60;];
% Setup MTEX preferences for crystal symmetry and plotting conventions.
% Defines crystal symmetry for Nickel superalloy with specified lattice parameters and color for plotting.
crystalSymmetry = {...
  'notIndexed',...
  crystalSymmetry('m-3m', [3.6 3.6 3.6], 'mineral', 'Ni-superalloy', 'color', [0.53 0.81 0.98])};
setMTEXpref('xAxisDirection', 'west');  % Set the x-axis direction to west
setMTEXpref('zAxisDirection', 'outOfPlane');  % Set the z-axis direction out of plane

%% Specify File Names
% Define the paths for input data and output data
dataPath = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_ctf\';
outputDirCtf = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_ctf_regions\';
outputDirAng = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_ang_regions\';
timePoints = [5.0, 10.0, 20.0, 30.0];  % Define time points for analysis

% Loop through each time point to process EBSD data
for iRegion = 1:1 %length(boxSizes)
  for iTime = 3:3
      % Path to input file and Import the Data
      inputFile = fullfile(dataPath, sprintf('Ni_%dmin_excerpt.ctf', timePoints(iTime)));
      ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                          'convertEuler2SpatialReferenceFrame');

      % Process the EBSD data to identify and smooth grains
      [grains, ebsdData] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);

      % Plot the initial IPF map
      % plotIPFMap(3*(iRegion-1)+1, ebsdData, grains);

      % Define region of interest within the EBSD data
      [xmin, xmax, ~, ~] = ebsdData.extend;
      ebsdLocal = ebsdData(inpolygon(ebsdData, [boxSizes(iRegion, 1), boxSizes(iRegion, 2), boxSizes(iRegion, 3), boxSizes(iRegion, 4)])); % local-5
      % Transform the mesh to increase resolution
      ebsdLocalMesh = transformMesh(ebsdLocal, 4.0);

      % Iterate through different smoothing parameters
      alphaValues = [0.0, 1.0];
      for iFill = 1:length(alphaValues)
        [grainsLocalMesh, ebsdLocalMesh] = identifyAndSmoothGrains(ebsdLocalMesh, 2.0 * degree, 60, 3.0);
        F = halfQuadraticFilter;
        F.alpha = alphaValues(iFill);
        ebsdLocalMesh = smooth(ebsdLocalMesh, F, 'fill', grainsLocalMesh);
        ebsdLocalMesh = ebsdLocalMesh('indexed');
      end

      % Final identification and smoothing of grains
      [grainsLocalMesh, ebsdLocalMesh] = identifyAndSmoothGrains(ebsdLocalMesh, 2.0 * degree, 60, 3.0);

      % Plot the second IPF map after further processing
      plotIPFMap(3*(iRegion-1)+2, ebsdLocalMesh, grainsLocalMesh);

      % Reduce mesh resolution for final processing
      % ebsdLocalMesh = transformMesh(ebsdLocalMesh, 2.0);
      % [grainsLocalMesh, ebsdLocalMesh] = identifyAndSmoothGrains(ebsdLocalMesh, 2.0 * degree, 60, 3.0);
      % plotIPFMap(3*(iRegion-1)+3, ebsdLocalMesh, grainsLocalMesh);

      % % Output processed data in CTF format
      % outputFile = fullfile(outputDirCtf, sprintf('Ni_%dmin_region%d.ctf', timePoints(iTime), iRegion));
      % export_ctf(ebsdLocalMesh, outputFile);

      % % Output processed data in ANG format
      % outputFile = fullfile(outputDirAng, sprintf('Ni_%dmin_region%d.ang', timePoints(iTime), iRegion));
      % export_ang(ebsdLocalMesh, outputFile);
  end
end
% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\experiments\exp31_get_regions_from_excerpts.m

% sum(grainsLocalMesh.grainSize) % 像素点
% grainsLocalMesh(11).grainSize
% [xmin, xmax, ymin, ymax] = ebsdLocalMesh.extend;
% grainArea = (ymax - ymin) * (xmax - xmin)
% sum(grainsLocalMesh.grainSize) 