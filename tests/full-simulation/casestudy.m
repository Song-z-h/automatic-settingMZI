function [VC,VC_ideal,powerc1,prc_ideal,it] =casestudy(PR_A,desired_theta,desired_phi,imperfections)



i=1;

Power_measured=[];
phase_measured=[];
phase_true=[];
VC_measured=[];
VC_true=[];
target_b=[];
target_c=[];
V_heater=0;
psi=0;
phi=0;
    theta=0;
    max_iter=100000;
    it=0;
    delta_a=50;
    delta_b=50;
    delta_c=50;
    dpr_target_b=1;
    dpr_target_c=-1;
    check=-1;
    derivative=1;
 
    %while check<0 & it<1000000
    while abs(delta_a)>1e-3 & it<100000
    [psi,delta_a]=MZI_A([1;0],PR_A,psi,imperfections,derivative);
    it=it+1;
    end
    [~,~,out_a]=mzi_model_input(psi,[1;0],imperfections);
     out_a_ideal=[-0.4990 + 0.5000i;
   0.5000 - 0.5010i];
    %out_a_ideal=[1/sqrt(2);1/sqrt(2)];
    PR_B=0.5+abs(out_a(1))*abs(out_a(2))*sin(desired_phi+(angle(out_a(2))-angle(out_a(1))));
    target_b=[target_b,PR_B];
     while abs(delta_b)>1e-3 & it<100000
    [phi, delta_b] = MZI_B(out_a,PR_B, phi, imperfections, dpr_target_b);
    it=it+1;
     end
     it=0;
    [~, powerb2, outb] = mzi_model_bottomArm(phi, out_a, imperfections);
    [~,PR_C]=simulate_MZI(desired_phi,desired_theta,out_a);
    target_c=[target_c,PR_C];

     while abs(delta_c)>1e-3 & it<100000 
    [theta, delta] = MZI_C(outb,PR_C, theta, imperfections, dpr_target_c);
     it=it+1;
     end
    
    % if delta_a<1e-3 && delta_b<1e-3 && delta_c<1e-3
    %     check=1
    % end
    % it=it+1;

   [powerc1, ~, VC] = mzi_model_topArm(theta, outb, imperfections);
    %end
  
 
   [VC_ideal,prc_ideal]=simulate_MZI(desired_phi,desired_theta,out_a_ideal);


   
end


