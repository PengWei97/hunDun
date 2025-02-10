% ---------------------------------------------------------
% Script Name: exp3a5_transform_ctf2inl_s1.m
% Created by: Peng Wei
% Date: October 27, 2024
% Purpose: To visualize IPF maps of GNSNi samples at different time points 
%          using taichang's EBSD data and MTEX toolbox.
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
inputDataPath = 'H:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\ctf2_stages_14mins\';
outputDataPath = 'H:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\ang_stages_14mins\';
outputDataPath2 = 'H:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\ctf2_rho_stages_14mins\';

for iStage = 3:3
  % Generate the full file path for each time point
  localId = getLocalIds(iStage);
  [m, ~] = size(localId);

  for jLocal = 4:4
    inputFile = fullfile(inputDataPath, sprintf('GNSNi2_14min_Stage%d_local%da%d.ctf', iStage, localId(jLocal,1),  localId(jLocal,2))); 

    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf',...
                'convertEuler2SpatialReferenceFrame');

    plot(ebsdData, ebsdData.orientations)

    [xmin, ~, ymin, ~] = ebsdData.extend();
    ebsdData = ebsdData(inpolygon(ebsdData, [xmin, ymin, 100, 100]));

    % output ang
    outputFileAng = fullfile(outputDataPath, sprintf('GNSNi2_14min_Stage%d_local%da%d_test.ang', iStage, localId(jLocal,1),  localId(jLocal,2)));
    export_ang(ebsdData, outputFileAng);

    % % Calculate GND map from the EBSD data
    % ebsdGrid = ebsdData('indexed').gridify;
    % rho = calculatedFCCGNDs(ebsdGrid); % Function to calculate GND density

    % % Initial grain calculation
    % [grains, ebsdData.grainId, ebsdData.mis2mean] = calcGrains(ebsdData, 'threshold', 2 * degree);
    % grains = smooth(grains, 10);

    % plotGNDsMap(2, ebsdGrid, grains, rho); % Function to plot the GND map
    
    % % Specify the output .fig file path for exporting
    % outputFileCtf = fullfile(outputDataPath2, sprintf('GNSNi2_14min_Stage%d_local%da%d.ctf', iStage, localId(jLocal,1), localId(jLocal,2)));
    % export_ctf(ebsdGrid, rho, outputFileCtf); % export_ctfb
  end
end

function local_ids = getLocalIds(iStage) % depend on the grain size 
  switch iStage
      case 1
        local_ids = [1,5; 2,1; 2,3; 3,1; 3,3; 4,1; 5,1; 5,3; 6,3; 7,1;];
      case 2
        local_ids = [1,2; 1,4; 2,2; 7,2];
      case 3
        local_ids = [1,1; 1,3; 2,4; 4,2; 7,3; 7,4];
      case 4
        local_ids = [3,2; 5,2; 6,1; 6,2; 8,1];
  end
end
