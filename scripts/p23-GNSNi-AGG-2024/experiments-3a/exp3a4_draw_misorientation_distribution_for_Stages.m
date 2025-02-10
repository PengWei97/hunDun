% ---------------------------------------------------------
% Script Name: exp3a4_draw_misorientation_distribution_for_Stages.m
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
inputeDataPath = 'H:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\csv2_MADs_14mins\';

% Visualization parameters
figWidth = 16; 
figHeight = 18 * 0.618;
fontSizeLabelTitle = 18;
colors = {'#0085c3', '#14d4f4', '#f2af00', '#b7295a', '#00205b', '#009f4d', '#84bd00', '#efdf00', '#e4002b', '#a51890'};

% Loop over each time point to load and plot the corresponding EBSD data
totalMADTable = [];
for iStage = 1:4
  % Generate the full file path for each time point
  localId = getLocalIds(iStage);
  [m, ~] = size(localId);

  for jLocal = 1:m
    % break;

    inputFile = fullfile(inputeDataPath, sprintf('GNSNi2_14min_Stage%d_local%da%d.csv', iStage, localId(jLocal,1),  localId(jLocal,2))); 

    ebsdData = readtable(inputFile);
    
    x = ebsdData.edges;
    y = ebsdData.numFraction;
    notes = sprintf('Local%da%d', localId(jLocal,1),  localId(jLocal,2));

    figure(jLocal)
    bar(x, y,...
      'FaceColor', colors{3},...
      'DisplayName',notes);
    xlabel('Misorientation Angle (^\circ)', ... % xlabel('R (\mum)', ...
        'FontSize', fontSizeLabelTitle, ...
        'FontWeight', 'bold', ...
        'Color', 'k', ...
        'FontName', 'Times New Roman');
    ylabel('Number Fraction (%)', ...
          'FontSize', fontSizeLabelTitle, ...
          'FontWeight', 'bold', ...
          'Color', 'k', ...
          'FontName', 'Times New Roman');
    set(gca, 'FontSize', 16, ...
        'LineWidth', 2.0, ...
        'FontName', 'Times New Roman'); % Set x and y axes

    % xlim([0 70]);
    % ylim([0 50]); 
    set(gcf, 'Unit', 'centimeters', 'Position', [0, 0, figWidth, figHeight])
    legend('FontSize', 18, 'TextColor', 'black', 'Location', 'northeast', 'NumColumns', 1);
    set(gcf, 'Color', 'None'); % Set figure window color to transparent
    set(gca, 'Color', 'None'); % Set axes background color to transparent
  end

  inputFile = fullfile(inputeDataPath, sprintf('GNSNi2_14min_Stage%d_total.csv', iStage)); 
  ebsdData = readtable(inputFile);
  
  x = ebsdData.edges;
  y = ebsdData.numFraction;
  notes = sprintf('Stage-%d', iStage);

  figure(iStage)
  bar(x, y,...
    'FaceColor', colors{3},...
    'DisplayName',notes);
  xlabel('Misorientation Angle (^\circ)', ... % xlabel('R (\mum)', ...
      'FontSize', fontSizeLabelTitle, ...
      'FontWeight', 'bold', ...
      'Color', 'k', ...
      'FontName', 'Times New Roman');
  ylabel('Number Fraction (%)', ...
        'FontSize', fontSizeLabelTitle, ...
        'FontWeight', 'bold', ...
        'Color', 'k', ...
        'FontName', 'Times New Roman');
  set(gca, 'FontSize', 16, ...
      'LineWidth', 2.0, ...
      'FontName', 'Times New Roman'); % Set x and y axes

  % xlim([0 70]);
  % ylim([0 50]);

  
  xlim([0 70]);
  ylim([0 10]);
  set(gcf, 'Unit', 'centimeters', 'Position', [0, 0, figWidth, figHeight])
  legend('FontSize', 18, 'TextColor', 'black', 'Location', 'northeast', 'NumColumns', 1);
  set(gcf, 'Color', 'None'); % Set figure window color to transparent
  set(gca, 'Color', 'None'); % Set axes background color to transparent
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