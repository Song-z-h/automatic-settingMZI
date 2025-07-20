    function [power1, power2, E_out] = mzi_model_bottomArm(ps, E_in, imperfections)
    % Simulates the MZI with one phase shifter on the bottom arm
    %
    % Inputs:
    %   ps          - Phase shift from the first phase shifter (radians).
    %   E_in         - 2x1 column vector of the input electric fields.
    %   imperfections- Struct with fields: epsilon, loss_ps
    %
    % Outputs:
    %   power1    - Optical power at the internal point 1.
    %   power2    - Optical power at the internal point 2.


    % Create component matrices
    T_dc = DirectionalCouplers(imperfections.epsilon);
    T_ps = PhaseShifter_bottomArm(ps, imperfections.loss_ps);

    % Field Propagation cascading each conponents
    E_out = T_dc * T_ps * E_in;

    % Power Calculation
    power1 = abs(E_out(1))^2;
    power2 = abs(E_out(2))^2;
end