function singleKineticsTable = calculateSingleKinetics(inputDir, simCase, grainIds)
  % calculateSingleKinetics Calculate average kinetics for grain growth data.
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
  %   resultsTable = calculateSingleKinetics(dir, caseId);
  
  % Load total data
  inputFileTotal = fullfile(inputDir, sprintf('out_%s.csv', simCase));
  totalData = readtable(inputFileTotal);
  time = totalData.time;

  % Initialize the results table
  numGrains = length(grainIds);
  variableTypes = repmat({'double'}, 1, numGrains + 2);
  variableNames = [{'time'}, arrayfun(@(x) sprintf('gr%d', x), grainIds, 'UniformOutput', false), {'runTime'}];

  singleKineticsTable = table('Size', [length(time), numGrains + 2], ...
                              'VariableTypes', variableTypes, ...
                              'VariableNames', variableNames);

  singleKineticsTable.time = time;
  singleKineticsTable.runTime = totalData.run_time;

  % Process each time point
  for iTimePoint = 2:length(time)
      % disp(['Simulation time: ', num2str(time(iTimePoint)), 's.']);
      csvFileName = sprintf('out_%s_grain_volumes_%04d.csv', simCase, iTimePoint - 1);
      csvData = readtable(fullfile(inputDir, csvFileName));
      
      for iGrainID = 1:numGrains
        grainID = grainIds(iGrainID);
        columnName = sprintf('gr%d', grainID);

        grainVolume = csvData.feature_volumes(csvData.feature_id == grainID);
        grainsRadius = sqrt(grainVolume /pi); % Calculate radius for 2D
        singleKineticsTable.(columnName)(iTimePoint) = grainsRadius;
      end  
  end
end
