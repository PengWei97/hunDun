% ---------------------------------------------------------
% Script Name: exp3a1_draw_grain_size_distribution_stages.m
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
inputDataPath = 'G:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\csv2_stages_14mins\';

% Loop over each time point to load and plot the corresponding EBSD data
for iStage = 1:4 % 2:length(yCoordinatesBox)
  % Generate the full file path for each time point
  localId = getLocalIds(iStage);    
  [m, ~] = size(localId);
  for jLocal = 1:m
    inputFile = fullfile(inputDataPath, sprintf('GNSNi2_14min_Stage%d_local%da%d_grainDatas.csv', iStage, localId(jLocal,1), localId(jLocal,2)));

    grainDataTable = readtable(inputFile);

    grainArea = grainDataTable.grainArea;
    grainID = grainDataTable.grainID;

  
    [tempGrainSizeDistribution, edges] = createGrainSizeDistribution(31, 3.0); % 2.5 for stage 1; 2-
    [tempGrainSizeDistribution.numFraction, tempGrainSizeDistribution.areaFraction, aveGrainRadius, bigGrainIDs] = getGrainSizeDistribution(grainArea, edges, grainID);

    formattedMessage = sprintf('big grain id in %d and %d:', localId(jLocal, 1), localId(jLocal, 2));
    disp(formattedMessage);
    disp(bigGrainIDs')
    grainSizeDistribution = tempGrainSizeDistribution;
    % xSegm = edges(tempGrainSizeDistribution.areaFraction > 0);
    % numFraction = tempGrainSizeDistribution.numFraction(tempGrainSizeDistribution.areaFraction > 0);
    % areaFraction = tempGrainSizeDistribution.areaFraction(tempGrainSizeDistribution.areaFraction > 0);

    % grainSizeDistribution = table(xSegm, numFraction, areaFraction,...
    %                               'VariableNames', {'xSegm', 'numFraction', 'areaFraction'});

    figure(10*(iStage-1)+jLocal+1) % meanOrientation + grain id + arrow
    bar(grainSizeDistribution.xSegm, grainSizeDistribution.areaFraction,... % .* aveGrainRadius
        'FaceColor', colors{2},...
        'DisplayName',sprintf("<R>: %.2f", aveGrainRadius));

    % xlabel('R/<R>', ...
    xlabel('R (\mum)', ...
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

    set(gcf, 'Unit', 'centimeters', 'Position', [0, 0, figWidth, figHeight])
    legend('FontSize', 18, 'TextColor', 'black', 'Location', 'best', 'NumColumns', 1);
    set(gcf, 'Color', 'None'); % Set figure window color to transparent
    set(gca, 'Color', 'None'); % Set axes background color to transparent
    % End of script
  end
end

function local_ids = getLocalIds(iStage)
  switch iStage
      case 1
        local_ids = [1,2; 1,5; 2,3; 3,1; 3,3; 4,1; 5,1; 5,3; 6,3; 7,1;];
      case 2
        local_ids = [1,4; 2,1; 2,2; 4,2; 7,2;];
      case 3
        local_ids = [1,1; 1,3; 2,4; 3,2; 5,2; 6,1; 7,3; 8,1];
      case 4
        local_ids = [6,2; 7,4;];
  end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% add GB type maps
% deltaMisor = 5 * degree;
% gb_nickel = grainsLocal.boundary('Ni-superalloy','Ni-superalloy');
% lAGB = gb_nickel(angle(gb_nickel.misorientation) < 15.0 * degree);     % Low-angle GBs (< 15°)
% hAGB = gb_nickel(angle(gb_nickel.misorientation) >= 15.0 * degree);    % High-angle GBs (≥ 15°)

% % Identify CSL boundaries with misorientation tolerance
% gB3 = gb_nickel(gb_nickel.isTwinning(CSL(3, ebsdLocal.CS), deltaMisor)); % CSL Σ3 (twin boundaries)
% gB9 = gb_nickel(gb_nickel.isTwinning(CSL(9, ebsdLocal.CS), deltaMisor)); % CSL Σ9

% % figure(numFigType*(jLocal-1)+2) % GB type map
% plot(hAGB, 'lineColor', 'black', 'linewidth', 2, 'micronbar', 'off','coordinates','on'); % High-angle GBs
% hold on
% plot(lAGB, 'lineColor', 'Indigo', 'linewidth', 3, 'micronbar', 'off'); % Low-angle GBs
% plot(gB3, 'lineColor', 'gold', 'linewidth', 3, 'DisplayName', 'CSL 3'); % Σ3 Twin boundaries
% plot(gB9, 'lineColor', 'magenta', 'linewidth', 3, 'DisplayName', 'CSL 9');
% text(bigGrains,int2str(bigGrains.id),'color','black')
% legend off  

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(numFigType*(jLocal-1)+2) % Misorientation angle
% plot(grainsLocal,'translucent',0.5,'micronbar','off','coordinates','on');
% legend off
% hold on
% plot(gb_nickel,gb_nickel.misorientation.angle./degree,'linewidth',2)
% mtexColorMap('jet');
% hold on
% mtexColorbar('title','misorientation angle');
% text(bigGrains,int2str(bigGrains.id),'color','black')      


% figure(numFigType*(jLocal-1)+2) % GB
% plot(gb_nickel, 'lineColor', 'black', 'linewidth', 2, 'micronbar', 'off','coordinates','on'); % High-angle GBs

% figure(numFigType*(jLocal-1)+3) % aspect ratio
% plot(grainsLocal,grainsLocal.aspectRatio)