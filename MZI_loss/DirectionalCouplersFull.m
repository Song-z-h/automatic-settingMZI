function T_dc = DirectionalCouplersFull(epsilon, loss_dB)      
    T_dc_old = DirectionalCouplers(epsilon);
    alpha = 10^(-loss_dB / 20);     % Uniform loss
    T_dc = alpha * T_dc_old;
end

%perturb epsilon, in real devices kappa and tau may be slightly lossy or phase-shifted.