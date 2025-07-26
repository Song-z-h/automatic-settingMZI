clear all; clc; close all;
%imperfections.epsilon = 0.00;
imperfections.loss_ps = 0.00;
PR_A = 0.5;
desired_phi = 1.8 * pi;
desired_theta = 0.15 * pi;

out_a_ideal = [-0.4990 + 0.5000i;
           0.5000 - 0.5010i];

epsilons = -0.2 : 0.005 : 0.2;
n_eps = length(epsilons);
power_measured = zeros(1, n_eps);
phase_measured = zeros(1, n_eps);

for i = 1:length(epsilons)
    imperfections.epsilon = epsilons(i);
    
    % Run simulation
    [VC, VC_ideal, powerc1, prc_ideal, it] = casestudy(PR_A, desired_theta, desired_phi, imperfections);
    % Store results
    power_measured(i) = powerc1;
    phase_measured(i) = angle(VC(1)) - angle(VC(2));
end

% Ideal output for reference

[VC_ideal, prc_ideal] = simulate_MZI(desired_phi, desired_theta, out_a_ideal);
phase_true = angle(VC_ideal(1)) - angle(VC_ideal(2));
power_true = prc_ideal;

% Compute errors
phase_error = abs(phase_measured - phase_true);
power_error = abs(power_measured - power_true);

%% Phase Error Plot
figure;
plot(epsilons, phase_error, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
xline(0.12, 'r--', 'LineWidth', 2)
title("Phase Error vs \epsilon", 'FontSize', 14, 'FontWeight', 'bold');
xlabel("\epsilon", 'FontSize', 12);
ylabel("Phase Error", 'FontSize', 12);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
box on;

%% Power Error Plot
figure;
plot(epsilons, power_error, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
xline(0.12, 'r--', 'LineWidth', 2)
title("Power Error vs \epsilon", 'FontSize', 14, 'FontWeight', 'bold');
xlabel("\epsilon", 'FontSize', 12);
ylabel("Power Error", 'FontSize', 12);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
box on;
