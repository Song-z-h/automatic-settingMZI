clear all
imperfections.epsilon = 0.00;
imperfections.loss_ps = 0.00;
PR_A=0.5;
desired_phi=1.8*pi;
desired_theta=0.15*pi;
Power_measured=[];
phase_measured=[];
phase_true=[];
VC_measured=[];
VC_true=[];
for epsilon=0.00:0.005:0.2
    imperfections.epsilon=epsilon;
    [VC,VC_ideal,powerc1,prc_ideal,it] =casestudy(PR_A,desired_theta,desired_phi,imperfections);
    Power_measured=[Power_measured,powerc1];
    phase_measured=[phase_measured;angle(VC(2))-angle(VC(1))];
end
 out_a_ideal=[-0.4990 + 0.5000i;
   0.5000 - 0.5010i];
[VC_ideal,prc_ideal]=simulate_MZI(desired_phi,desired_theta,out_a_ideal);
phase_true=angle(VC_ideal(2))-angle(VC_ideal(1));
power_true=prc_ideal;
phase_error=phase_measured-phase_true;
power_error=Power_measured-power_true;
epsilon=0.00:0.005:0.2;
figure;
plot(epsilon,phase_error);
title("phase error vs \epsilon")
grid on
figure
plot(epsilon,power_error);
title("power error vs epsilon")
grid on

