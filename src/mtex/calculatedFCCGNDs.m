function rho = calculatedFCCGNDs(ebsdInterp)
  cs = ebsdInterp.CS;

  kappa = ebsdInterp.curvature;
  % alpha = kappa.dislocationDensity; % the incomplete dislocation density tensor
  dS = dislocationSystem.fcc(cs); % Crystallographic Dislocations
  dSRot = ebsdInterp.orientations * dS; % to rotate the dislocation tensors into the specimen reference frame as well
  [rho_single,factor] = fitDislocationSystems(kappa,dSRot); % Fitting Dislocations to the incomplete dislocation density tensor
  alpha = sum(dSRot.tensor .* rho_single,2); % the restored dislocation density tensors
  alpha.opt.unit = '1/um'; % we have to set the unit manualy since it is not stored in rho
  % kappa = alpha.curvature; % we may also restore the complete curvature tensor with
  rho = factor*sum(abs(rho_single),2); % calculate dislocation density
end