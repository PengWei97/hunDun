function plotCSVDataCurve(inputDir, inputFile, index, lengthName, columnNames, params, factorY)
  % plotCSVDataCurve Plot a data curve from a CSV file.
  % This function reads data from a CSV file, applies a scaling factor to the y-values,
  % filters out non-positive values, and plots the resulting data.
  %
  % Inputs:
  %   inputDir - String, the directory where the input file is located.
  %   inputFile - String, the filename of the CSV file to read.
  %   index - Integer, index used for selecting color and line style from the params struct.
  %   lengthName - String, the label for the plot's legend.
  %   columnNames - Cell array containing two strings, names of the columns in the CSV
  %                 file to use for the x and y axes, respectively.
  %   params - Struct, contains styling parameters for the plot such as colors, line width,
  %            and line style.
  %   factorY - Optional double, a factor to scale the y-values. Defaults to 1 if not provided.
  %
  % Example:
  %   plotCSVDataCurve('./data', 'example.csv', 1, 'Sample Data', {'Time', 'Amplitude'}, params, 2)

  % Check if factorY is provided, if not, default it to 1
  if nargin < 8
      factorY = 1;
  end

  % Read the CSV file to a table
  inputFileKinetic = fullfile(inputDir, inputFile);
  dataTable = readtable(inputFileKinetic);

  % Extract x and y data based on column names provided
  x = dataTable.(columnNames{1});
  y = dataTable.(columnNames{2}) .* factorY;
  x = x(y > 0);  % Filter out non-positive y values
  y = y(y > 0);

  % Plot the data using specified styling parameters
  plot(x, y, ...
      'Color', params.colors{index}, ...
      'LineWidth', params.lineWidth, ...
      'LineStyle', params.lineStyles{index}, ...
      'DisplayName', lengthName);
end
