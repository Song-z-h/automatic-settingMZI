function [V_heater, delta] = feedback_loop(PR_A, pr_target ,V_heater, dpr_target)

    % Compute error between measured and target PR
    delta = PR_A - pr_target;

    if sign(delta * dpr_target)>0
        X=-1;
     else 
        X=1;
     end
    k=25e-3;

    V_heater=V_heater+k*delta*X;
 
        if V_heater>2*pi
       n= floor(V_heater/(2*pi));
        V_heater=V_heater-2*pi*n;
    else if V_heater<0
         n=ceil(abs((V_heater/(2*pi))));
         V_heater=V_heater+2*pi*n;
    end

end
