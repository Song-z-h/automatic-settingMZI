function [V_heater,residual] = MZI_A(E_in, target,V_heater,ps, imperfections, h)
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

    [power1, power2] = mzi_model_input(ps, E_in, imperfections);
    [powerh1, powerh2] = mzi_model_input(ps + h, E_in, imperfections);
    [pr, dpr, ~, ~] = get_power_ratios_devivative(power1, power2, powerh1, powerh2, h);
    

    %update the output vector
    [V_heater, residual] = feedback_loop(pr,dpr,target,V_heater);

 end
