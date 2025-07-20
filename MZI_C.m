function [ps ,residual] = MZI_C(E_in, target,ps, imperfections, dpr_target)
    % INPUT: 
    % E_in: input vector (complex), can be not normalised
    % phase shifts in radians
    % target: the target phase shifter's phase shift
    % ps: phase shifter
    % imperfections: [epsilon,loss_ps] DC loss, ps loss
    % h: update interval
    % OUTPUT:
    %   V_heater    : output vector (complex)
    %   residual  : error between target and measured ps

    % estimate the power ratio
    %h = 25e-3;

    [power1, power2, ~] = mzi_model_topArm(ps, E_in, imperfections);
    %[powerh1, powerh2, ~] = mzi_model_topArm(ps + h, E_in, imperfections);
    %[pr, dpr, ~, ~] = get_power_ratios_devivative(power1, power2, powerh1, powerh2, h);
    pr = power1 / (power1 + power2 + eps);

    %update the output vector
    [ps, residual] = feedback_loop(pr,target,ps, dpr_target);

 end
