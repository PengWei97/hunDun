grainIds =  [1346, 1315, 1300, 1315, 798, 749, 559, 488, 466, 441, 126];
% grainIds =  [409, 422, 405, 352, 267, 252, 185, 168, 151, 146, 68];
grainData = table;
grainData.grainID = grainIds';

[xmin, xmax, ymin, ymax] = ebsdLocalMesh.extend;
boxSize = (xmax - xmin) * (ymax - ymin);
grainSizeTotal = sum(grainsLocalMesh.grainSize);

for igrainId = 1:length(grainIds)
  grainId = grainIds(igrainId);
  grainSize = grainsLocalMesh(grainId).grainSize * boxSize / grainSizeTotal;

  grainData.grainRadius(igrainId) = sqrt(grainSize / pi);
end

grainData

% E:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\experiments\exp32_get_grainSize_based_grainID_exp.m