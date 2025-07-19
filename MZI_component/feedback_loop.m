function [V_heater,deltaPR_A] = feedback_loop(PR_A, dPR_A, target,V_heater)
    % INPUT: 
    % PR_A: power ratio at one arm
    % dPR_A: derivative of the pr with respect to a ps
    % V_heater: the output vector to be updated
    % target: the target phase shifter's phase shift
    % OUTPUT:
    %   V_heater    : output vector (complex)
    %   delta  : error between target and measured ps    
     
    deltaPR_A=PR_A-target;
    if deltaPR_A>=0
        X=1-2*(dPR_A<0);
    else 
        X=-1+2*(dPR_A<0);
    end
    k=25e-3;
    V_heater=V_heater+k*deltaPR_A*X;

 end
