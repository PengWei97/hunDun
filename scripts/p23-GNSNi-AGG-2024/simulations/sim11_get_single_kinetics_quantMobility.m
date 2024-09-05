clear
close all
clc

% inputDirs = {'csv_qp_Reg1_1', 'csv_qp_Reg1_2', 'csv_qp_Reg1_3', 'csv_qp_Reg1_4', 'csv_qp_Reg4_1'};
inputDirs = {'csv_qp_Reg4_1'};
outputDir = 'E:\Github\MyRhinoLab\data\output\p23-GNSNi-AGG-2024\simulations\paramQuant';
temperature = 600;

% grainIDs = [97, 57, 42]; % region-1
grainIDs = [60, 69, 99, 118]; % region-4 

% Loop over all cases
for iCases = 1:length(inputDirs)
  [inputDir, simCase] = setDirectories(inputDirs{iCases});

  % get the average kinetic of simulation
  singleKineticsTable = calculateSingleKinetics(inputDir, simCase, grainIDs);

  % Construct the output file path and save the data
  outputFileKinetic = fullfile(outputDir, 'gBMobility', sprintf('Ni%ddu_kinetics_v%d_region4.csv', temperature, iCases));
  saveCSVData(singleKineticsTable, outputFileKinetic);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\simulations\sim11_get_single_kinetics_quantMobility.m

function [inputDir, simCase] = setDirectories(inputDirLast)
  baseDir = 'E:\temp\p23_GNSNi_2024\paramQuant\qp_regions\';
  inputDir = fullfile(baseDir, inputDirLast);
  simCase = strrep(inputDirLast, 'csv_', ''); % Strip 'csv_' prefix
end

