clear
close all
clc

inputDirs = {'csv_test_iso_15s', 'csv_test_iso_15s_gt', 'csv_test_iso_15s_fine'};
outputDir = 'E:\Github\MyRhinoLab\data\output\p23-GNSNi-AGG-2024\simulations\';
temperature = 700;

% Loop over all cases
for iCases = 1:length(inputDirs)
  [inputDir, simCase] = setDirectories(inputDirs{iCases});

  % % get the average kinetic of simulation
  % aveKineticsTable = calculateAveKinetics(inputDir, simCase);

  % % Construct the output file path and save the data
  % outputFileKinetic = fullfile(outputDir, 'csv_kinetics', sprintf('Ni%ddu_kinetics_%s.csv', temperature, simCase));
  % saveCSVData(aveKineticsTable, outputFileKinetic);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\simulations\sim01_get_ave_kinetics.m
function [inputDir, simCase] = setDirectories(inputDirLast)
  baseDir = 'E:\temp\p23_GNSNi_2024\';
  inputDir = fullfile(baseDir, inputDirLast);
  simCase = strrep(inputDirLast, 'csv_', ''); % Strip 'csv_' prefix
end

% E:\temp\p23_GNSNi_2024\csv_test_iso_gt\out_test_iso_gt.csv

