function aveKineticsTable = calculateAveKinetics(inputDir, simCase)
  % calculateAveKinetics Calculate average kinetics for grain growth data.
  %
  % This function processes time-series data of grain volumes from CSV files,
  % calculating the average grain radius, total grain count, and the weighted
  % standard deviation of grain sizes for each time point.
  %
  % Inputs:
  %   inputDir - String specifying the directory where input files are stored.
  %   simCase - String identifier for the simulation case, used to generate file names.
  %
  % Output:
  %   aveKineticsTable - MATLAB table containing time, average grain radius,
  %                      grain count, and weighted standard deviation per time point.
  %
  % Example:
  %   dir = 'path/to/data';
  %   caseId = 'test_case_01';
  %   resultsTable = calculateAveKinetics(dir, caseId);
  
  % Load total data
  inputFileTotal = fullfile(inputDir, sprintf('out_%s.csv', simCase));
  totalData = readtable(inputFileTotal);
  time = totalData.time;  

  % Initialize the results table
  aveKineticsTable = table('Size', [length(time), 5], ...
                           'VariableTypes', {'double', 'double', 'double', 'double', 'double'}, ...
                           'VariableNames', {'time', 'weightedAveGrainRadius', 'GrainNum', 'WeightedStd', 'runTime'});
  aveKineticsTable.time = time;
  aveKineticsTable.runTime = totalData.run_time;

  % Process each time point
  for iTimePoint = 2:length(time)
      % disp(['Simulation time: ', num2str(time(iTimePoint)), 's.']);
      csvFileName = sprintf('out_%s_grain_volumes_%04d.csv', simCase, iTimePoint - 1);
      csvData = readtable(fullfile(inputDir, csvFileName));
      grainVolumes = csvData.feature_volumes(csvData.feature_volumes > 0);

      if isempty(grainVolumes)
          continue;
      end

      % Calculate radii and statistics for grains
      grainsRadius = sqrt(grainVolumes ./ pi); % Calculate radius for 2D
      grainNumber = length(grainsRadius);
      weightedAvgRadius = sum(grainsRadius .* grainVolumes) / sum(grainVolumes);
      weightedStd = sqrt(sum((grainsRadius - weightedAvgRadius).^2 .* grainVolumes) / sum(grainVolumes)); % Weighted standard deviation

      % Store computed values in the results table
      aveKineticsTable.GrainNum(iTimePoint) = grainNumber;
      aveKineticsTable.weightedAveGrainRadius(iTimePoint) = weightedAvgRadius;
      aveKineticsTable.WeightedStd(iTimePoint) = weightedStd; % Weighted standard deviation    
  end
end
