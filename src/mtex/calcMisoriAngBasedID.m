function misAng = calcMisoriAngBasedID(grain1, grain2, grains)
  ori1 = grains(grain1).meanOrientation;
  ori2 = grains(grain2).meanOrientation;
  misAng = angle(ori1, ori2) ./ degree;
end

% misAng = calcMisoriAngBasedID(1, 2, grains)