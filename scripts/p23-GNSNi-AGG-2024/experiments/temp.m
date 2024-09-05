% Clear all figures, variables, and command window to start fresh
close all;
clear;
clc;

%% Setup File Paths and Parameters
inputPathInl = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_inl\';
inputPathCtf = '.\data\p23_GMSNi_AGG_2024\exp_data\ebsd_ctf_rho\';
outputDir = inputPathInl;
timePoints = [5.0, 10.0, 20.0, 30.0];

% Process each specified time point
for iTime = 2:2 % Loop over specified indices, change to 'length(timePoints)' for full processing
    processDataPoints(inputPathInl, inputPathCtf, timePoints(iTime));
end

function processDataPoints(inputPathInl, inputPathCtf, timePoint)
    % Process data for a given time point
    % Load INL and CTF data
    dataInl = readtable(fullfile(inputPathInl, sprintf('Ni_%dmin_local1.csv', timePoint)));
    dataCtf = readtable(fullfile(inputPathCtf, sprintf('Ni_%dmin_local1_rho.csv', timePoint)));

    % Determine critical rho values for filtering
    minCriticalRho = min(dataCtf.Rho(dataCtf.Rho > 100)) - 10;
    maxCriticalRho = max(dataCtf.Rho);

    % Visualize Rho distributions
    plotRhoDistributions(dataInl, dataCtf);

    % Adjust rho values based on identified features
    dataCtf = adjustRhoValues(dataInl, dataCtf, minCriticalRho, maxCriticalRho);

    % Output adjusted data
    outputAdjustedData(dataInl, dataCtf, inputPathInl, timePoint);
end

function plotRhoDistributions(dataInl, dataCtf)
    % Plot log-scaled Rho values from INL and CTF data
    figure;
    scatter(dataInl.x, dataInl.y, 20, log(dataCtf.Rho), 'filled');
    title('Log-scaled Rho values from INL data');
    colorbar;

    figure;
    scatter(dataCtf.X, dataCtf.Y, 20, log(dataCtf.Rho), 'filled');
    title('Log-scaled Rho values from CTF data');
    colorbar;
end

function dataCtf = adjustRhoValues(dataInl, dataCtf, minCriticalRho, maxCriticalRho)
    % Adjust Rho values based on grain feature identification
    for iFeature = 1:max(dataInl.FeatureId)
        rhoGrain = dataCtf.Rho(dataInl.FeatureId == iFeature);
        rhoFiltered = rhoGrain(rhoGrain > minCriticalRho);

        if isempty(rhoFiltered)
            dataCtf.Rho(dataInl.FeatureId == iFeature) = maxCriticalRho;
            continue;
        end

        rhoAverage = max(mean(rhoFiltered), minCriticalRho);
        indices = find(dataInl.FeatureId == iFeature);
        dataCtf.Rho(indices(dataCtf.Rho(indices) < minCriticalRho)) = rhoAverage;
        dataCtf.Rho(isnan(dataCtf.Rho(indices))) = maxCriticalRho;
    end

    dataCtf.Rho(dataCtf.Rho < minCriticalRho) = maxCriticalRho;
    return
end

function outputAdjustedData(dataInl, dataCtf, outputPath, timePoint)
    % Output adjusted data to a CSV file
    dataOutput = dataInl;
    fieldsToConvert = {'phi1', 'PHI', 'phi2', 'x', 'y', 'z'};
    precisions = {'%.6f', '%.6f', '%.6f', '%.6f', '%.6f', '%.2f'};

    for iVariable = 1:length(fieldsToConvert)
        dataOutput.(fieldsToConvert{iVariable}) = strtrim(cellstr(num2str(dataInl.(fieldsToConvert{iVariable}), precisions{iVariable})));
    end

    dataOutput.Rho = strtrim(cellstr(num2str(dataCtf.Rho,'%.6e')));
    outputFilename = sprintf('Ni_%dmin_local1_rho_inl.csv', timePoint);
    writetable(dataOutput, fullfile(outputPath, outputFilename), 'Delimiter', ' ');
end
