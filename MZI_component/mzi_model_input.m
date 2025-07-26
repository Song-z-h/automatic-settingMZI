function [power1, power2, E_out] = mzi_model_input(ps, E_in, imperfections)
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

    %model loss
    p = check_imperfection_fields(imperfections);
    T_loss = ArmImbalanceLoss(p.alpha_top, p.alpha_bottom);


    % Create component matrices
    T_dc1 = DirectionalCouplers(p.epsilon);
    T_dc2 = DirectionalCouplers(p.epsilon);

    T_ps = PhaseShifter_topArm(ps + p.thermal_drift, p.loss_ps);

    % Field Propagation cascading each conponents
    E_out = T_dc2 * T_loss* T_ps * T_dc1 * E_in;

    % Power Calculation
    power1 = abs(E_out(1))^2;
    power2 = abs(E_out(2))^2;
end