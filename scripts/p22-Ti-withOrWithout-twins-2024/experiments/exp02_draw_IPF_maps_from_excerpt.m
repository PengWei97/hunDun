close all
clear all
clc

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/mmm', [3 3 4.7], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Ti-Hex', 'color', [0.53 0.81 0.98])};

% Set plotting convention
setMTEXpref('xAxisDirection','north'); 
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names
dataPath = '.\data\p22_Ti_withOrWithout_twins\exp_data\excerpt_ctf\';
timePoints = [0, 10, 15, 30, 60];
caseTypes = {'with_twins', 'without_twins'};

numTypeFigures = 2;
gbs_length = zeros(4, 6);
for iCase = 1:1
  for iTime = 1:1 % 1:length(timePoints)
      % Path to files 
      inputFile = fullfile(dataPath, sprintf('Ti_%s_%dmin_excerpt.ctf',caseTypes{iCase}, timePoints(iTime)));
      
      %% Import the Data
      ebsdData = EBSD.load(inputFile, CS, 'interface', 'ctf', ...
                          'convertEuler2SpatialReferenceFrame');

      % ebsdData = ebsdData(inpolygon(ebsdData, [0, 0, 20, 20]));
      [grains, ebsdData] = identifyAndSmoothGrains(ebsdData, 2.0 * degree, 10, 3.0);
      
      rot=rotation('Euler', 0*degree, 90*degree, 0*degree);
      ebsdData=rotate(ebsdData,rot,'keepXY');

      % 绘制IPF maps
      idFigure = numTypeFigures*(iTime-1)*(iCase-1)+1;
      plotIPFMap(idFigure, ebsdData, grains); 

      % 绘制PF
      cs = CS{2}
      h=[Miller(0,0,0,1,cs), Miller(1,0,-1,0,cs), Miller(1,1,-2,0,cs)];
      figure(2)
      plotPDF(ebsdData('Ti-Hex').orientations, h, 'contourf');
      mtexColorbar

      % % set(gcf, 'Unit', 'centimeters', 'Color', 'None');
      % % set(gca, 'Color', 'None'); % Set axes background color to transparent      

      % % Identify grain boundaries
      % [twinBoundary1, twinBoundary2, twinBoundary3, twinBoundary4, lowAngleGB, highAngleGB] = identifyGBsTi(grains, ebsdData);
      % % 绘制GB maps
      % figure(3)
      % plotGrainBoundaryMaps(lowAngleGB, highAngleGB, twinBoundary1, twinBoundary2, twinBoundary3, twinBoundary4, 3);

      % % KAM map
      % ebsdGrid = ebsdData.gridify;
      % kam = ebsdGrid.KAM / degree;
      % figure(4)
      % plot(ebsdGrid, kam,'micronbar', 'off')
      % mtexColorbar
      % mtexColorMap WhiteJet
      % hold on
      % plot(grains.boundary,'lineWidth',1.5)
      % hold off  
      
      % % GOS distribution
      % mis2mean = calcGROD(ebsdData, grains);
      % GOS = ebsdData.grainMean(mis2mean.angle);
      % % draw GOS distribution
      % figure(5)
      % plot(grains, GOS ./ degree, 'micronbar', 'on', 'coordinates', 'off'); % 
      % mtexColorbar('title','GOS in degree');
      % set(gca, 'CLim', [0 5]);
      % hold on;
      % plot(grains.boundary, 'linewidth', 0.8);
      % hold off;
    
      % % Calculate GNDs
      % ebsdGrid = ebsdData('indexed').gridify;
      % rho = calculateGNDsTi(ebsdGrid);
      % % GND map
      % figure(6);
      % plot(ebsdGrid, rho, 'micronbar', 'on', 'coordinates', 'off');
      % mtexColorMap('jet');
      % set(gca, 'ColorScale', 'log');
      % set(gca, 'CLim', [7.0e12 10.0e15]);
      % mtexColorbar('title', 'Dislocation Density (1/m^2)');
      % hold on;
      % plot(grains.boundary, 'linewidth', 0.8);
      % hold off;
  end
end
% E:\Github\MyRhinoLab\scripts\p22-Ti-withOrWithout-twins-2024\experiments\exp02_draw_IPF_maps_from_excerpt.m

function plotGrainBoundaryMaps(lowAngleGB, highAngleGB, twinBoundary1, twinBoundary2, twinBoundary3, twinBoundary4, figureIndex)
  figure(figureIndex);
  plot(highAngleGB, 'linecolor', 'Black', 'linewidth', 1, 'displayName', 'High angle grain boundary');
  hold on;
  plot(lowAngleGB, 'linecolor', 'blue', 'linewidth', 1.5, 'displayName', 'Low angle grain boundary');
  plot(twinBoundary1, 'linecolor', 'gold', 'linewidth', 3, 'displayName', 'Tensile twin boundary v1');
  plot(twinBoundary2, 'linecolor', 'g', 'linewidth', 3, 'displayName', 'Compression twin boundary v1');
  plot(twinBoundary3, 'linecolor', 'm', 'linewidth', 3, 'displayName', 'Tensile twin boundary v2');
  plot(twinBoundary4, 'linecolor', 'c', 'linewidth', 3, 'displayName', 'Compression twin boundary v2');
  hold off;

  lgd = legend('FontSize', 18, 'TextColor', 'black', 'Location', 'southeast', 'NumColumns', 1, 'FontName', 'Times New Roman');
  set(lgd, 'Visible', 'on');
end