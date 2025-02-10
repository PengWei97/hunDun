% ---------------------------------------------------------
% Script Name: exp3a3_get_misorientation_distribution_for_Stages.m
% Created by: Peng Wei
% Date: October 27, 2024
% Purpose: To visualize IPF maps of GNSNi samples at different time points 
%          using taichang's EBSD data and MTEX toolbox.
% ---------------------------------------------------------

% Close all figures, clear workspace, and command window
close all;
clear;
clc;

%% File paths and time points
inputeDataPath = 'H:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\ctf2_stages_14mins\'; 
outputDataPath1 = 'H:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\csv2_MADs_14mins\';
% Define crystal symmetry for Ni-superalloy
crystalSymmetry = {... 
    'notIndexed', ...
    crystalSymmetry('m-3m', [3.6 3.6 3.6], 'mineral', 'Ni-superalloy', 'color', [0.53 0.81 0.98])};

% Set plotting preferences: x-axis direction as east, z-axis as into the plane
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','inOfPlane');

% Loop over each time point to load and plot the corresponding EBSD data
for iStage = 4:4

  clear totalMisoriAng
  totalMisoriAng = [];
  % Generate the full file path for each time point
  localId = getLocalIds(iStage);
  [m, ~] = size(localId);

  for jLocal = 2:2
    inputFile = fullfile(inputeDataPath, sprintf('GNSNi2_14min_Stage%d_local%da%d.ctf', iStage, localId(jLocal,1),  localId(jLocal,2))); 

    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf',...
                'convertEuler2SpatialReferenceFrame');

    % figure(3*(jLocal - 1) + 1)
    % plot(ebsdData, ebsdData.orientations, 'coordinates', 'on');

    [grains, ebsdData.grainId, ebsdData.mis2mean] = calcGrains(ebsdData, 'threshold', 2.0 * degree);

    % figure(1)
    plot(grains,grains.meanOrientation,'micronbar','off','coordinates','on');
    hold on 
    bigGrains = grains(grains.grainSize>500); % (grainsLocal.grainSize>1000)
    dir = bigGrains.meanOrientation * Miller(1,0,0,bigGrains.CS);
    len = 0.5.*bigGrains.diameter;
  
    quiver(bigGrains,len.*dir,'autoScale','off','color','white')
    text(bigGrains,int2str(bigGrains.id),'color','black')

    % %% GB
    % gB = grains.boundary;
    % gb_nickel = gB('Ni-superalloy', 'Ni-superalloy');
    % gb_inner = grains.innerBoundary('Ni-superalloy', 'Ni-superalloy');
    % gb_all = [gb_nickel; gb_inner];

    % % misorientation of GB
    % misori = gb_all.misorientation;

    % % Axes and misorienation angle of GB
    % ax = misori.axis;
    % misoriAng = misori.angle./degree;
    % [counts, edges] = hist(misoriAng, 30);

    % MADTable = table(edges', counts' ./ sum(counts) .* 100, 'VariableNames',  {'edges', 'numFraction'});
    % outputFileName = fullfile(outputDataPath1, sprintf('GNSNi2_14min_Stage%d_local%da%d.csv', iStage, localId(jLocal,1),  localId(jLocal,2))); 
    % writetable(MADTable, outputFileName);
    
    % if (jLocal == 1)
    %   totalMisoriAng = misoriAng;
    % else
    %   totalMisoriAng = [totalMisoriAng; misoriAng];
    % end

    % % GOS map
    % notes = sprintf('S%d-Local%da%d', iStage, localId(jLocal,1),  localId(jLocal,2));
    % mis2mean = calcGROD(ebsdData, grains);
    % GOS = ebsdData.grainMean(mis2mean.angle);
    % figure(jLocal)
    % plot(grains, GOS ./ degree, 'micronbar', 'off', 'coordinates', 'on');
    % set(gca, 'CLim', [0 2.5]);
    % mtexColorbar('title','GOS in degree');
    % hold on;
    % plot(grains.boundary, 'linewidth', 1.0, 'lineColor', 'white');
    % hold off;

    % dispSentence = sprintf('max of local%da%d in Stage %d: %f', localId(jLocal,1), localId(jLocal,2), iStage, max(GOS ./ degree));
    % disp(dispSentence)
  end

  % [totalCounts, totalEdges] = hist(totalMisoriAng, 30);
  % totalMADTable = table(totalEdges', totalCounts' ./ sum(totalCounts) .* 100, 'VariableNames',  {'edges', 'numFraction'});
  % outputFileName = fullfile(outputDataPath1, sprintf('GNSNi2_14min_Stage%d_total.csv', iStage)); 
  % writetable(totalMADTable, outputFileName);
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