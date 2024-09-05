% Function to calculate dislocation density
function rho = calculateGNDsTi(ebsdInterp)
    
  cs = ebsdInterp.CS;

  % Define crystal slip systems
  sS_basal_sym  = slipSystem.basal(cs).symmetrise('antipodal'); % Basal slip
  sS_prism_sym  = slipSystem.prismaticA(cs).symmetrise('antipodal'); % Prismatic slip
  sS_pyrIA_sym  = slipSystem.pyramidalA(cs).symmetrise('antipodal'); % First order pyramidal slip
  sS_pyrIAC_sym = slipSystem.pyramidalCA(cs).symmetrise('antipodal');
  sS_pyrIIAC_sym = slipSystem.pyramidal2CA(cs).symmetrise('antipodal'); % Second order pyramidal slip pyramidal2CA pyramidalCA2

  slipSystems_all = {sS_basal_sym, sS_prism_sym, sS_pyrIA_sym, sS_pyrIAC_sym, sS_pyrIIAC_sym};
  slipSystems_all_sym = [];
  for i_numSlip = 1:length(slipSystems_all)
      for j = 1:length(slipSystems_all{i_numSlip})
          slipSystems_all_sym = [slipSystems_all_sym; slipSystems_all{i_numSlip}(j)];
      end
  end

  % Dislocation density tensor
  dS = dislocationSystem(slipSystems_all_sym);
  dSRot = ebsdInterp.orientations * dS; % to rotate the dislocation tensors into the specimen reference frame as well
  kappa = ebsdInterp.curvature;
  [rho_single,factor] = fitDislocationSystems(kappa,dSRot); % Fitting Dislocations to the incomplete dislocation density tensor
  alpha = sum(dSRot.tensor .* rho_single,2); % the restored dislocation density tensors
  alpha.opt.unit = '1/um'; % we have to set the unit manualy since it is not stored in rho
  % kappa = alpha.curvature; % we may also restore the complete curvature tensor with
  rho = factor*sum(abs(rho_single),2); % calculate dislocation density
end