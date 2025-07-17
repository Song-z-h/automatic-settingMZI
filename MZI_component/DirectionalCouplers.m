function T_dc = DirectionalCouplers(epsilon)
  kappa = sqrt(0.5 + epsilon);      % Coupling coefficient
  tau = sqrt(0.5 - epsilon);        % Transmission coefficient
  T_dc = [tau, -1i*kappa; -1i*kappa, tau];
end

