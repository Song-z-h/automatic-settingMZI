function T_dc = DirectionalCouplers(epsilon)
  kappa = sqrt(0.5 + epsilon);      % Coupling coefficient
  tau = sqrt(0.5 - epsilon);        % Transmission coefficient
  T_dc = [tau, -1i*kappa; -1i*kappa, tau];
end
%for a lossless coupler, kappa^2 + tau^2 = 1
%In this case we don't have loss of power, but epsilon is a 
% perturbation from an ideal 50/50 (3 dB) directional coupler
