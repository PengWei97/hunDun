ori1 = grainsLocal(100).meanOrientation;

grain_ids = [97 121 125 141]
misori = zeros(1,length(grain_ids));
for i = 1:length(grain_ids)
    ori2 = grainsLocal(grain_ids(i)).meanOrientation;

    misori(i) = round(angle(ori1, ori2) ./ degree, 2);
end
misori
% D:\Github\MyRhinoLab\scripts\p23-GNSNi-AGG-2024\experiments-3a\exp3a1_calculated_misorientation_angle.m