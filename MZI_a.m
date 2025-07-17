 function [V_heater,deltaPR_A] = MZI_a(target,V_heater,psi)
    % INPUT: phase shifts in radians
    % OUTPUT:
    %   VC    : output vector (complex)
    %   PR_C  : output power ratio (amplitude^2 of 1st component)
    %   chi_C : phase difference between outputs (in radians)
    EA = [1/sqrt(2);1/sqrt(2)];
    PR_A=0.5+EA(1)*EA(2)*sin(psi);
    dPR_A=EA(1)*EA(2)*cos(psi);
    deltaPR_A=PR_A-target;
    if deltaPR_A>=0
        X=1-2*(dPR_A<0);
    else 
        X=-1+2*(dPR_A<0);
    end
    k=25e-3;
    V_heater=V_heater+k*deltaPR_A*X;



 end
