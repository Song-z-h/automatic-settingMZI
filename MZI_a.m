 function [psi,deltaPR_A] = MZI_a(target,V_heater,psi,derivative)
    EA=[1,0];
    PR_A=sin(psi/2).^2*EA(1);

    deltaPR_A=PR_A-target;
     if deltaPR_A*derivative>0
        X=-1;
     else 
       X=1;
     end
    k=25e-3;
   
    V_heater=V_heater+k*deltaPR_A*X;
    psi=V_heater;
    %psi=psi+V_heater*2*pi/50;
    % 
    % if V_heater<0
    %     V_heater=V_heater+2*pi;
    % end
    if psi>2*pi
       n= floor(psi/(2*pi));
        psi=psi-2*pi*n;
    else if psi<0
         n=ceil(abs((psi/(2*pi))));
         psi=psi+2*pi*n;
    end

end




  %EA = [1/sqrt(2);1/sqrt(2)];
    % dPR_A=0.5*sin(psi);

   % PR_A=0.5+EA(1)*EA(2)*sin(psi);
   % dPR_A=EA(1)*EA(2)*cos(psi);


       % dPR_A=-1
    % if deltaPR_A>=0
    %     X=1-2*(dPR_A<0);
    % else 
    %     X=-1+2*(dPR_A<0);
    % end