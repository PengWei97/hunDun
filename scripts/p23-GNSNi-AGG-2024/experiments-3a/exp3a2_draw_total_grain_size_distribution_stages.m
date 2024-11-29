% ---------------------------------------------------------
% Script Name: exp3a2_draw_total_grain_size_distribution_stages.m
% Created by: Peng Wei
% Date: October 27, 2024
% Purpose: To visualize IPF maps of GNSNi samples at different time points 
%          using taichang's EBSD data and MTEX toolbox.
% ---------------------------------------------------------

% Close all figures, clear workspace, and command window
close all;
clear;
clc;

% Visualization parameters
figWidth = 16; 
figHeight = 18 * 0.618;
fontSizeLabelTitle = 18;
colors = {'#0085c3', '#14d4f4', '#f2af00', '#b7295a', '#00205b', '#009f4d', '#84bd00', '#efdf00', '#e4002b', '#a51890'};

%% File paths and time points
inputDataPath = 'H:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\csv2_stages_14mins\';

% Loop over each time point to load and plot the corresponding EBSD data
totalGrainDataTable = [];
for iStage = 1:1
  % Generate the full file path for each time point
  localId = getLocalIds(iStage);
  [m, ~] = size(localId);

  for jLocal = 1:m
    inputFile = fullfile(inputDataPath, sprintf('GNSNi2_14min_Stage%d_local%da%d_grainDatas.csv', iStage, localId(jLocal,1), localId(jLocal,2)));

    grainDataTable = readtable(inputFile);
  
    if jLocal == 1
      totalGrainDataTable = grainDataTable;
    else
      totalGrainDataTable = vertcat(totalGrainDataTable, grainDataTable);
    end
  end

  grainArea = grainDataTable.grainArea;
  grainID = grainDataTable.grainID;

  [grainSizeDistribution, edges] = createGrainSizeDistribution(31, 3.0); % 2.5 for stage 1; 2-
  [grainSizeDistribution.numFraction, grainSizeDistribution.areaFraction, aveGrainRadius, bigGrainIDs] = getGrainSizeDistribution(grainArea, edges, grainID);

  figure(iStage) % meanOrientation + grain id + arrow
  bar(grainSizeDistribution.xSegm, grainSizeDistribution.areaFraction,... % .* aveGrainRadius
      'FaceColor', colors{2},...
      'DisplayName',sprintf("<R>: %.2f", aveGrainRadius));

  xlabel('R/<R>', ... % xlabel('R (\mum)', ...
      'FontSize', fontSizeLabelTitle, ...
      'FontWeight', 'bold', ...
      'Color', 'k', ...
      'FontName', 'Times New Roman');
  ylabel('Area Fraction (%)', ...
        'FontSize', fontSizeLabelTitle, ...
        'FontWeight', 'bold', ...
        'Color', 'k', ...
        'FontName', 'Times New Roman');
  set(gca, 'FontSize', 16, ...
      'LineWidth', 2.0, ...
      'FontName', 'Times New Roman'); % Set x and y axes
  xlim([0 3])
  % xlim([0 100])
  ylim([0 0.25])
  set(gcf, 'Unit', 'centimeters', 'Position', [0, 0, figWidth, figHeight])
  legend('FontSize', 18, 'TextColor', 'black', 'Location', 'best', 'NumColumns', 1);
  set(gcf, 'Color', 'None'); % Set figure window color to transparent
  set(gca, 'Color', 'None'); % Set axes background color to transparent
  % End of script
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
