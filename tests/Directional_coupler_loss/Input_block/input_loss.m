clear all; clc; close all;
imperfections.loss_ps = 0.00;
%Ein = [-0.4990 + 0.5000i;
 %          0.5000 - 0.5010i];
Ein =[ 1; 1i] /sqrt(2);
epsilons = -0.49 : 0.005 : 0.49;

n_eps = length(epsilons);
power_measured = zeros(1, n_eps);
phase_measured = zeros(1, n_eps);


psi = 4.7144;

[power1, power2, E_out] = mzi_model_input(psi, Ein, imperfections);



T_output_ideal = E_out;
prc_ideal = abs(E_out(1)).^2;

for i = 1:length(epsilons)
    imperfections.epsilon = epsilons(i);

    [~, ~, VC] = mzi_model_input(psi, Ein, imperfections);

    powerc1 = abs(VC(1)).^2;
    power_measured(i) = powerc1;
    phase_measured(i) = angle(VC(1)) - angle(VC(2));
end

% Ideal output for reference

%[VC_ideal, prc_ideal] = simulate_MZI(desired_phi, desired_theta, out_a_ideal);
phase_true = angle(T_output_ideal(1)) - angle(T_output_ideal(2));
power_true = prc_ideal;

% Compute errors
phase_error = abs(phase_measured - phase_true);
power_error = abs(power_measured - power_true);

%% Phase Error Plot
figure;
plot(epsilons, phase_error, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
%xline(0.12, 'r--', 'LineWidth', 2)
title("Phase Error vs \epsilon", 'FontSize', 14, 'FontWeight', 'bold');
xlabel("\epsilon", 'FontSize', 12);
ylabel("Phase Error", 'FontSize', 12);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
box on;

%% Power Error Plot
figure;
plot(epsilons, power_error, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
%xline(0.12, 'r--', 'LineWidth', 2)
title("Power Error vs \epsilon", 'FontSize', 14, 'FontWeight', 'bold');
xlabel("\epsilon", 'FontSize', 12);
ylabel("Power Error", 'FontSize', 12);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
box on;
