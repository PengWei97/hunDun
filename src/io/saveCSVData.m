function saveCSVData(tableData, outputFileDir)
  % saveCSVData Save data to a CSV file.
  %
  % Function to save a MATLAB table to a CSV file. It first checks if the
  % directory where the file will be saved exists, creates it if necessary,
  % and then saves the table data to the file.
  %
  % Inputs:
  %   tableData - A MATLAB table containing the data to be saved.
  %   outputFileDir - A string specifying the full path and filename of the
  %                   output CSV file.
  %
  % Output:
  %   None explicitly returned, but a CSV file is written to the disk.
  %
  % Example:
  %   data = array2table(rand(5,2), 'VariableNames', {'A', 'B'});
  %   saveCSVData(data, 'C:\data\output\data.csv');

  % Check if the output directory exists, create it if it does not
  if ~exist(fileparts(outputFileDir), 'dir')
    mkdir(fileparts(outputFileDir));
  end

  % Save the data to CSV
  writetable(tableData, outputFileDir); 
  disp(['Data saved successfully to ', outputFileDir]);
end