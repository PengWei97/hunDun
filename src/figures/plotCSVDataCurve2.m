function plotCSVDataCurve2(x, y, index, params)
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

  % Plot the data using specified styling parameters
  plot(x, y, ...
      'Color', params.colors{index}, ...
      'LineWidth', params.lineWidth, ...
      'LineStyle', params.lineStyles{index});
end