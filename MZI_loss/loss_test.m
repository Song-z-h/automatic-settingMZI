clear all;

params = generateMZIparams();

%epsilon: directional coupler imbalance
T_dc1 = DirectionalCouplersFull(params.epsilon, params.loss_dc_dB);


T_ps_top = PhaseShifter_topArm(params.phase_top + params.thermal_drift, params.loss_top_dB);
T_ps_bot = PhaseShifter_bottomArm(params.phase_bottom + params.thermal_drift, params.loss_bottom_dB);

T_loss = ArmImbalanceLoss(params.alpha_top, params.alpha_bottom);
T_dc2 = DirectionalCouplersFull(params.epsilon, params.loss_dc_dB);

U = T_dc2 * T_loss * T_ps_bot * T_ps_top * T_dc1

if isfield(params, 'thermal_drift')
    p = 1
end
g = true
if(g)
    g = false
end

