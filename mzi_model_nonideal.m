    function [power_B2, power_C1, power_C2] = mzi_model_nonideal(phi, theta, E_in, imperfections)
    % Simulates the optical fields and powers within a NON-IDEAL MZI.
    %
    % Inputs:
    %   phi          - Phase shift from the first phase shifter (radians).
    %   theta        - Phase shift from the second phase shifter (radians).
    %   E_in         - 2x1 column vector of the input electric fields.
    %   imperfections- Struct with fields: epsilon1, epsilon2, loss_ps_phi, loss_ps_theta
    %
    % Outputs:
    %   power_B2     - Optical power at the internal point B2.
    %   power_C1     - Optical power at the output port C1.
    %   power_C2     - Optical power at the output port C2.

    % Create component matrices
    T_dc1 = DirectionalCouplers(imperfections.epsilon1);
    T_dc2 = DirectionalCouplers(imperfections.epsilon2);
    T_phi = PhaseShifter(phi, imperfections.loss_ps_phi);
    T_theta = PhaseShifter(theta, imperfections.loss_ps_theta);

    % Field Propagation cascading each conponents
    E_A_prime = T_phi * E_in;
    E_B = T_dc1 * E_A_prime;
    E_B_prime = T_theta * E_B;
    E_C = T_dc2 * E_B_prime;

    % Power Calculation
    power_B2 = abs(E_B(2))^2;
    power_C1 = abs(E_C(1))^2;
    power_C2 = abs(E_C(2))^2;
end