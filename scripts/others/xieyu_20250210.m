close all
clear
clc

input_data_path = 'H:\Github\MyRhinoLabData\others\xieyu\';

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('m-3m', [3.6 3.6 3.6], 'mineral', 'Ni-superalloy', 'color', [0.53 0.81 0.98])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

fname = [input_data_path 'Project_1_CCN-1100-6-900-30MIN_Site_3_Map_Date_30.ctf'];

ebsd = EBSD.load(fname, CS, 'interface', 'ctf', 'convertEuler2SpatialReferenceFrame');

plot(ebsd, ebsd.orientations);

% % 
% [xmin, xmax, ymin, ymax] = ebsd.extend();
% ebsd = ebsd(inpolygon(ebsd, [0, 0, 300, 300]));

%% 细化、filling，降噪等
ebsdToRefine = transformMesh(ebsd, 2.0);

% Iterate through different smoothing parameters
alphaValues = [0.0, 1.0];
for iFill = 1:length(alphaValues)
  [grainsToRefine, ebsdToRefine] = identifyAndSmoothGrains(ebsdToRefine, 2.0 * degree, 60, 40.0);
  F = halfQuadraticFilter;
  F.alpha = alphaValues(iFill);
  ebsdToRefine = smooth(ebsdToRefine, F, 'fill', grainsToRefine);
  ebsdToRefine = ebsdToRefine('indexed');
end

figure(2)
[grainsToRefine, ebsdToRefine] = identifyAndSmoothGrains(ebsdToRefine, 2.0 * degree, 60, 3.0);
plot(ebsdToRefine, ebsdToRefine.orientations);
hold on
plot(grainsToRefine.boundary, 'lineWidth', 0.5);

% H:\Github\MyRhinoLab\scripts\others\xieyu_20250210.m