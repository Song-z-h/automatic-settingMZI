function [pr1, dpr1, pr2, dpr2] = get_power_ratios_devivative(power1, power2, powerh1, powerh2, h)
    %this function estimate the derivative of power ratio of both arms
    pr1 = power1 / (power1 + power2 + eps);
    pr2 = power2 / (power1 + power2 + eps);
    prh1 = powerh1 / (powerh1 + powerh2 + eps);
    prh2 = powerh2 / (powerh1 + powerh2 + eps);
    %prh2, pr2, h
    %prh1, pr1
    dpr1 = (prh1 - pr1) / h;
    dpr2 = (prh2 - pr2) / h;


end
