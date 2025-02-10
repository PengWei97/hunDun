function [grainSizeDistributionTable, edges] = createGrainSizeDistribution(segmNum, maxValue)
    % 创建等间隔的边界
    edges = linspace(0, maxValue, segmNum)';  % 转置为列向量

    % 计算中间值 x_segm
    xSegm = (edges(1:end-1) + edges(2:end)) / 2;  % 中间值

    % 初始化 numFraction 和 areaFraction
    numFraction = zeros(length(xSegm), 1);
    areaFraction = zeros(length(xSegm), 1);

    % 创建表格
    grainSizeDistributionTable = table(xSegm, numFraction, areaFraction, ...
                                       'VariableNames', {'xSegm', 'numFraction', 'areaFraction'});
end
