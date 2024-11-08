% ---------------------------------------------------------
% Script Name: exp3a0_draw_IPF_maps_for_initial.m
% Created by: Peng Wei
% Date: October 27, 2024
% Purpose: To visualize IPF maps of GNSNi samples at different time points 
%          using taichang's EBSD data and MTEX toolbox.
% ---------------------------------------------------------

% Close all figures, clear workspace, and command window
close all;
clear;
clc;

% Define crystal symmetry for Ni-superalloy
crystalSymmetry = {... 
    'notIndexed', ...
    crystalSymmetry('m-3m', [3.6 3.6 3.6], 'mineral', 'Ni-superalloy', 'color', [0.53 0.81 0.98])};

% Set plotting preferences: x-axis direction as east, z-axis as into the plane
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','inOfPlane');

%% File paths and time points
dataPath = 'G:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\ctf_initial_14mins\';
outputDataPath1 = 'G:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\ctf2_stages_14mins\'; % Output directory
outputDataPath2 = 'G:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\csv2_stages_14mins\'; % Output directory
outputDataPath3 = 'G:\Github\MyRhinoLabData\p23_GNSNi_AGG_2024\ebsd\b1_GNSNi_EX_EBSD_14min_106_20241026\png2_stages_14mins\'; % Output directory
numFigType = 8;

pixelToArea = 0.0635;
% Loop over each time point to load and plot the corresponding EBSD data
for iTime = 1:8
    % Generate the full file path for each time point
    inputFile = fullfile(dataPath, sprintf('GNSNi_14min_20241026_local%d.ctf', iTime)); % for 106 for 14mins

    %% Load EBSD data from the specified file
    ebsdData = EBSD.load(inputFile, crystalSymmetry, 'interface', 'ctf', ...
                         'convertSpatial2EulerReferenceFrame'); % convertSpatial2EulerReferenceFrame convertEuler2SpatialReferenceFrame

    % filling ebsd Local
    ebsdData = transformMesh(ebsdData, 4.0);

    boxSize = getboxSize(iTime);
    [m, ~] = size(boxSize);
    for jLocal = 1:m
      if (boxSize(jLocal,7) ~= 4)
        continue;
      end

      fprintf("Region: %d, Local: %d;\n", boxSize(jLocal,5), boxSize(jLocal,6));

      % ebsdLocal = ebsdData(inpolygon(ebsdData,[boxSize(jLocal,1), boxSize(jLocal,2), boxSize(jLocal,3), boxSize(jLocal,4)]));
      ebsdLocal = ebsdData(inpolygon(ebsdData,[boxSize(jLocal,1), boxSize(jLocal,2)-240, boxSize(jLocal,3), 240]));
      [xmin, xmax, ymin, ymax] = ebsdLocal.extend();

      % Iterate through different smoothing parameters
      alphaValues = [0.0, 0.0];
      for iFill = 1:length(alphaValues)
        [grainsLocal, ebsdLocal] = identifyAndSmoothGrains(ebsdLocal, 2.0 * degree, 60, 3.0);
        F = halfQuadraticFilter;
        F.alpha = alphaValues(iFill);
        ebsdLocal = smooth(ebsdLocal, F, 'fill', grainsLocal);
        ebsdLocal = ebsdLocal('indexed');
      end

      ebsdLocal = ebsdLocal(inpolygon(ebsdLocal, [xmin, ymin, xmax-xmin, ymax - ymin]));
      [grainsLocal, ebsdLocal] = identifyAndSmoothGrains(ebsdLocal, 2.0 * degree, 60, 3.0);

      figure(5*(iTime-1)+jLocal+1) % meanOrientation + grain id + arrow
      plot(grainsLocal,grainsLocal.meanOrientation,'micronbar','off','coordinates','on');
      hold on 
      bigGrains = grainsLocal(grainsLocal.grainSize>500); % (grainsLocal.grainSize>1000)
      dir = bigGrains.meanOrientation * Miller(1,0,0,bigGrains.CS);
      len = 0.5.*bigGrains.diameter;
    
      quiver(bigGrains,len.*dir,'autoScale','off','color','white')
      text(bigGrains,int2str(bigGrains.id),'color','black')
      hold on
      deltaMisor = 5 * degree;
      gb_nickel = grainsLocal.boundary('Ni-superalloy','Ni-superalloy');
      lAGB = gb_nickel(angle(gb_nickel.misorientation) < 15.0 * degree);     % Low-angle GBs (< 15°)
      hAGB = gb_nickel(angle(gb_nickel.misorientation) >= 15.0 * degree);    % High-angle GBs (≥ 15°)

      % Identify CSL boundaries with misorientation tolerance
      gB3 = gb_nickel(gb_nickel.isTwinning(CSL(3, ebsdLocal.CS), deltaMisor)); % CSL Σ3 (twin boundaries)
      gB9 = gb_nickel(gb_nickel.isTwinning(CSL(9, ebsdLocal.CS), deltaMisor)); % CSL Σ9

      plot(hAGB, 'lineColor', 'black', 'linewidth', 2, 'micronbar', 'off','coordinates','on'); % High-angle GBs
      hold on
      plot(lAGB, 'lineColor', 'Indigo', 'linewidth', 3, 'micronbar', 'off'); % Low-angle GBs
      plot(gB3, 'lineColor', 'gold', 'linewidth', 3, 'DisplayName', 'CSL 3'); % Σ3 Twin boundaries
      plot(gB9, 'lineColor', 'magenta', 'linewidth', 3, 'DisplayName', 'CSL 9');
      text(bigGrains,int2str(bigGrains.id),'color','black')
      legend off        

      ipfMap = fullfile(outputDataPath3, sprintf('GNSNi2_14min_Stage%d_local%da%d_ipf.png',boxSize(jLocal,7), iTime, boxSize(jLocal,6)));
      print(gcf, '-dpng', '-r1200', ipfMap);

      % Specify the output CTF file path for exporting
      outputFile = fullfile(outputDataPath1, sprintf('GNSNi2_14min_Stage%d_local%da%d.ctf',boxSize(jLocal,7), iTime, boxSize(jLocal,6)));
      export_ctf(ebsdLocal, outputFile);  

      % output Grain Data with csv
      grainIDs = grainsLocal.id;
      grainAreas = grainsLocal(grainIDs).grainSize.*pixelToArea;
      phi1 = grainsLocal(grainsLocal.id).meanOrientation.phi1./degree;
      Phi = grainsLocal(grainsLocal.id).meanOrientation.Phi./degree;
      phi2 = grainsLocal(grainsLocal.id).meanOrientation.phi2./degree;

      grainTable = table(grainIDs,phi1,Phi,phi2,grainAreas,'VariableNames',{'grainID','phi1','Phi','phi2','grainArea'});
      filename = fullfile(outputDataPath2, sprintf('GNSNi2_14min_Stage%d_local%da%d_grainDatas.csv', boxSize(jLocal,7), iTime, boxSize(jLocal,6)));
      writetable(grainTable,filename);
    end
end

function box_size = getboxSize(i_local)
  switch i_local
      case 1
          box_size = [
              42, -20, 237, 180, 1, 1, 3; % local 1
              268, -20, 464-268, 120, 1, 2, 1;
              414, -20, 632-414, 180, 1, 3, 3;
              614, -20, 846-614, 120, 1, 4, 2;
              841, -20, 1000-841, 120, 1, 5, 1;
          ];
      case 2
          box_size = [
              0, -20, 114, 120, 2, 1, 2; % local 2
              104, -20, 297-104, 120, 2, 2, 2;
              276, -20, 386-276, 120, 2, 3, 1;
              345, -20, 800-345, 180, 2, 4, 3;
          ];
      case 3
          box_size = [
              28, -13, 153-28, 120, 3, 1, 1; % local 3
              133, -13, 596-133, 180, 3, 2, 3;
              580, -13, 800-580, 120, 3, 3, 1;
          ];
      case 4
          box_size = [
              0, -40, 214, 120, 4, 1, 1; % local 4
              189, -40, 573-189, 120, 4, 2, 2;
          ];
      case 5
          box_size = [
              0, -39, 289, 120, 5, 1, 1; % local 5
              256, -39, 637-256, 240, 5, 2, 3;
              594, -39, 692-594, 120, 5, 3, 1;
          ];
      case 6
          box_size = [
              97, -34, 470-97, 180, 6, 1, 3; % local 6
              500, -34, 805-500, 240, 6, 2, 4;
              770, -34, 1000-770, 120, 6, 3, 1;
          ];
      case 7
          box_size = [
              0, -24, 167, 120, 7, 1, 1; % local 7
              146, -24, 502-146, 180, 7, 2, 2;
              478, -24, 820-478, 180, 7, 3, 3;
              812, -24, 1000-812, 240, 7, 4, 4;
          ];
      otherwise
          box_size = [
              0, -28, 1007, 180, 8, 1, 3; % local 8
          ];
  end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% add GB type maps
% deltaMisor = 5 * degree;
% gb_nickel = grainsLocal.boundary('Ni-superalloy','Ni-superalloy');
% lAGB = gb_nickel(angle(gb_nickel.misorientation) < 15.0 * degree);     % Low-angle GBs (< 15°)
% hAGB = gb_nickel(angle(gb_nickel.misorientation) >= 15.0 * degree);    % High-angle GBs (≥ 15°)

% % Identify CSL boundaries with misorientation tolerance
% gB3 = gb_nickel(gb_nickel.isTwinning(CSL(3, ebsdLocal.CS), deltaMisor)); % CSL Σ3 (twin boundaries)
% gB9 = gb_nickel(gb_nickel.isTwinning(CSL(9, ebsdLocal.CS), deltaMisor)); % CSL Σ9

% % figure(numFigType*(jLocal-1)+2) % GB type map
% plot(hAGB, 'lineColor', 'black', 'linewidth', 2, 'micronbar', 'off','coordinates','on'); % High-angle GBs
% hold on
% plot(lAGB, 'lineColor', 'Indigo', 'linewidth', 3, 'micronbar', 'off'); % Low-angle GBs
% plot(gB3, 'lineColor', 'gold', 'linewidth', 3, 'DisplayName', 'CSL 3'); % Σ3 Twin boundaries
% plot(gB9, 'lineColor', 'magenta', 'linewidth', 3, 'DisplayName', 'CSL 9');
% text(bigGrains,int2str(bigGrains.id),'color','black')
% legend off  

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(numFigType*(jLocal-1)+2) % Misorientation angle
% plot(grainsLocal,'translucent',0.5,'micronbar','off','coordinates','on');
% legend off
% hold on
% plot(gb_nickel,gb_nickel.misorientation.angle./degree,'linewidth',2)
% mtexColorMap('jet');
% hold on
% mtexColorbar('title','misorientation angle');
% text(bigGrains,int2str(bigGrains.id),'color','black')      


% figure(numFigType*(jLocal-1)+2) % GB
% plot(gb_nickel, 'lineColor', 'black', 'linewidth', 2, 'micronbar', 'off','coordinates','on'); % High-angle GBs

% figure(numFigType*(jLocal-1)+3) % aspect ratio
% plot(grainsLocal,grainsLocal.aspectRatio)