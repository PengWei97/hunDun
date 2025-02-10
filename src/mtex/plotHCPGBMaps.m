% Function to plot grain boundary maps
function plotHCPGBMaps(lowAngleGB, highAngleGB, twinBoundary1, twinBoundary2, figureIndex)
    figure(figureIndex);
    plot(highAngleGB, 'linecolor', 'Black', 'linewidth', 1, 'displayName', 'High angle grain boundary');
    hold on;
    plot(lowAngleGB, 'linecolor', 'Indigo', 'linewidth', 1.5, 'displayName', 'Low angle grain boundary');
    plot(twinBoundary1, 'linecolor', 'Blue', 'linewidth', 1.5, 'displayName', 'Compression twin boundary');
    plot(twinBoundary2, 'linecolor', 'Red', 'linewidth', 1.5, 'displayName', 'Tensile twin boundary');
    hold off;

    lgd = legend('FontSize', 18, 'TextColor', 'black', 'Location', 'southeast', 'NumColumns', 1, 'FontName', 'Times New Roman');
    set(lgd, 'Visible', 'off');
end