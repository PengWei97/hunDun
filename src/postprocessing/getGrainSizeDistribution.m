function [numFraction, areaFraction, aveGrainRadius, bigGrainIDs] = getGrainSizeDistribution(grainVolumes, edges, grainIDs)
  % 计算晶粒半径
  grainRadius = sqrt(grainVolumes / pi);
  
  % 计算平均晶粒半径
  aveGrainRadius = sum(grainRadius .* grainVolumes) / sum(grainVolumes);
  % disp(["aveGrainRadius: %d/n", aveGrainRadius]);
  
  % 计算归一化的晶粒半径
  weightGrainRadius = grainRadius / aveGrainRadius;
  % disp(["maxWeightGrainRadius: %d/n", max(weightGrainRadius)]);

  numFraction = zeros(length(edges)-1, 1);
  areaFraction = zeros(length(edges)-1, 1);

  % 计算 numFraction 和 areaFraction
  for j = 1:length(weightGrainRadius)
    for i = 1:length(edges) - 1
        if weightGrainRadius(j) >= edges(i) && weightGrainRadius(j) < edges(i + 1)
            numFraction(i) = numFraction(i) + 1;  % 计数
            areaFraction(i) = areaFraction(i) + grainVolumes(j) / sum(grainVolumes);  % 计算面积分数
        end
    end
  end

  bigGrainIDs = grainIDs(weightGrainRadius > 2.5);
end
