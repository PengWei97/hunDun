% ---------------------------------------------------------
% Script Name: exp3a0_draw_IPF_maps_for_initial.m
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
dataPath = '.\data\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\ctf_initial_14mins\';
outputDataPath = '.\data\p23_GNS_AGG_106_20241026\ctf_stage1_14mins\'; % Output directory
numFigType = 8;

boxSize = [42,-200,237,180,1,1,3; % local 1
          268,-140,464-268,120,1,2,1;
          414,-200,632-414,180,1,3,3;
          614,-140,846-614,120,1,4,2;
          841,-140,1000-841,120,1,5,1;];

% boxSize = [0,-140,114,120,2,1,2; % local 2
%           104,-140,297-104,120,2,2,2;
%           276,-140,386-276,120,2,3,1;
%           345,-200,800-345,180,2,4,3;];
          
% boxSize = [28,-133,153-28,120,3,1,1; % local 3
%           133,-193,596-133,180,3,2,3;
%           580,-133,800-580,120,3,3,1;];

% boxSize = [0,-160,214,120,4,1,1; % local 4
%           189,-160,573-189,120,4,2,2;];

% boxSize = [0,-159,289,120,5,1,1; % local 5
%           256,-279,637-256,240,5,2,3;
%           594,-159,692-594,120,5,3,1;];

% boxSize = [97,-214,470-97,180,6,1,3; % local 6
%           500,-274,805-500,240,6,2,4;
%           770,-154,1000-770,120,6,3,1;];
          
% boxSize = [0,-144,167,120,7,1,1; % local 7
%           146,-204,502-146,180,7,2,2;
%           478,-204,820-478,180,7,3,3;
%           812,-264,1000-812,240,7,4,4;];

% boxSize = [0,-208,1007,180,8,1,7;]; % local 8

% Loop over each time point to load and plot the corresponding EBSD data
for iTime = 1:1 % 2:length(yCoordinatesBox)
    % Generate the full file path for each time point
    inputFile = fullfile(dataPath, sprintf('GNSNi_14min_20241026_local%d.ctf', iTime)); % for 106 for 14mins

    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertSpatial2EulerReferenceFrame'); % convertSpatial2EulerReferenceFrame convertEuler2SpatialReferenceFrame

    % Create a new figure for each time point
    % figure(3*(iTime-1)+1);
    % figure(1)
    % plot(ebsdData, ebsdData.orientations,'coordinates','on','micronbar','on');

    % filling ebsd Local
    ebsdData = transformMesh(ebsdData, 4.0);

    for jLocal = 2:2
      jLocal
      if (jLocal ~= 2) || (jLocal ~= 5)
        break;
      end

      ebsdLocal = ebsdData(inpolygon(ebsdData,[boxSize(jLocal,1), boxSize(jLocal,2), boxSize(jLocal,3), boxSize(jLocal,4)]));

      % Initial grain calculation
      [grainsLocal, ebsdLocal.grainId, ebsdLocal.mis2mean] = calcGrains(ebsdLocal, 'threshold', 2 * degree);
      grainsLocal = smooth(grainsLocal, 10);

      % Iterate through different smoothing parameters
      alphaValues = [0.0, 0.0];
      for iFill = 1:length(alphaValues)
        [grainsLocal, ebsdLocal] = identifyAndSmoothGrains(ebsdLocal, 2.0 * degree, 60, 3.0);
        F = halfQuadraticFilter;
        F.alpha = alphaValues(iFill);
        ebsdLocal = smooth(ebsdLocal, F, 'fill', grainsLocal);
        ebsdLocal = ebsdLocal('indexed');
      end

      figure(jLocal) % meanOrientation + grain id + arrow
      plot(grainsLocal,grainsLocal.meanOrientation,'micronbar','off','coordinates','on');
      hold on 
      bigGrains = grainsLocal(grainsLocal.grainSize>500); % (grainsLocal.grainSize>1000)
      dir = bigGrains.meanOrientation * Miller(1,0,0,bigGrains.CS);
      len = 0.5.*bigGrains.diameter;
    
      quiver(bigGrains,len.*dir,'autoScale','off','color','white');
      text(bigGrains,int2str(bigGrains.id),'color','black');
      hold on
      

      % Specify the output CTF file path for exporting
      outputFile = fullfile(outputDataPath, sprintf('GNSNi_14min_local%da%d_Stage%d.ctf', iTime, boxSize(jLocal,6), boxSize(jLocal,7)));
      export_ctf(ebsdLocal, outputFile);
    end
end