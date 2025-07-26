clear all
%imperfections.epsilon = 0.00;
imperfections.loss_ps = 0.00;
PR_A=0.5;
desired_phi=1.8*pi;
desired_theta=0.15*pi;
Power_measured=[];
phase_measured=[];
phase_true=[];
VC_measured=[];
VC_true=[];
for loss_ps=0.00:0.5:3
    %imperfections.epsilon=epsilon;
    imperfections.loss_ps=loss_ps;
    [VC,VC_ideal,powerc1,prc_ideal,it] =casestudy(PR_A,desired_theta,desired_phi,imperfections);
    Power_measured=[Power_measured,powerc1];
    phase_measured=[phase_measured;angle(VC(1))-angle(VC(2))];
end
 out_a_ideal=[-0.4990 + 0.5000i;
   0.5000 - 0.5010i];
[VC_ideal,prc_ideal]=simulate_MZI(desired_phi,desired_theta,out_a_ideal);
phase_true=angle(VC_ideal(1))-angle(VC_ideal(2));
VC_ideal
power_true=prc_ideal;
phase_error=phase_measured-phase_true;
power_error=Power_measured-power_true;
%epsilon=0.00:0.005:0.2;
loss_ps=0.00:0.5:3;
%%
% Phase Error Plot
figure;
plot(epsilon, phase_error, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
xline(0.12,'r--','LineWidth',2)
title("Phase Error vs \epsilon", 'FontSize', 14, 'FontWeight', 'bold');
xlabel("\epsilon", 'FontSize', 12);
ylabel("Phase Error", 'FontSize', 12);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
box on;

% Power Error Plot
figure;
plot(epsilon, power_error, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
xline(0.12,'r--','LineWidth',2)
title("Power Error vs \epsilon", 'FontSize', 14, 'FontWeight', 'bold');
xlabel("\epsilon", 'FontSize', 12);
ylabel("Power Error", 'FontSize', 12);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
box on;
%%
% Phase Error Plot
figure;
plot(loss_ps, phase_error, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
title("Phase Error vs \alpha_{dB}", 'FontSize', 14, 'FontWeight', 'bold');
xlabel("\alpha{dB}", 'FontSize', 12);
ylabel("Phase Error", 'FontSize', 12);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
box on;

% Power Error Plot
figure;
plot(loss_ps, power_error, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
title("Power Error vs \alpha_{dB}", 'FontSize', 14, 'FontWeight', 'bold');
xlabel("\alpha_{dB}", 'FontSize', 12);
ylabel("Power Error", 'FontSize', 12);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
box on;