% Main script to run the MZI feedback control simulation WITH IMPERFECTIONS

clear; clc; close all;

%% --- Define System Imperfections ---
imperfections.epsilon1 = 0.02;     % 2% splitting error in first DC
imperfections.epsilon2 = -0.01;    % -1% splitting error in second DC
imperfections.loss_ps_phi = 0.1;   % 0.1 dB loss in phi shifter's waveguide
imperfections.loss_ps_theta = 0.1; % 0.1 dB loss in theta shifter's waveguide

%% --- Simulation Setup ---
% Define the target working point (same as before)
phi_target_rad   = 1.8 * pi;
theta_target_rad = 0.15 * pi;

% Input vector
P_total_in = 1.0; % Total input power in mW
E_in = sqrt(P_total_in/2) * [1; 1];

% To find the PR targets, we must calculate them for an IDEAL MZI
ideal_imperfections.epsilon1 = 0;
ideal_imperfections.epsilon2 = 0;
ideal_imperfections.loss_ps_phi = 0;
ideal_imperfections.loss_ps_theta = 0;
[power_B2_target, power_C1_target, power_C2_target] = mzi_model_nonideal(phi_target_rad, theta_target_rad, E_in, ideal_imperfections);
P_total_out_target = power_C1_target + power_C2_target;

PR_B_target = power_B2_target / P_total_out_target;
PR_C_target = power_C1_target / P_total_out_target;

% Define derivative signs for the target
deriv_sign_B_target = 1; % +1 for positive slope
deriv_sign_C_target = 1; % +1 for positive slope

fprintf('Target PR(B): %.4f\n', PR_B_target);
fprintf('Target PR(C): %.4f\n', PR_C_target);

%% --- Controller and Simulation Parameters ---
k_phi   = 0.5;
k_theta = 0.5;
dt = 0.01;
T_final = 30; % Increased time slightly to ensure convergence with imperfections
time_vec = 0:dt:T_final;

% Initialize history arrays and initial phase values
phi_history   = zeros(size(time_vec));
theta_history = zeros(size(time_vec));
PR_B_history  = zeros(size(time_vec));
PR_C_history  = zeros(size(time_vec));
phi_rad   = 0;
theta_rad = 0;

%% --- Run the Simulation Loop ---
for i = 1:length(time_vec)
    % 1. Get ideal power values from the NON-IDEAL MZI model
    [power_B2_ideal, power_C1_ideal, power_C2_ideal] = mzi_model_nonideal(phi_rad, theta_rad, E_in, imperfections);

    % 2. Simulate noisy measurements (using the same photodetector model)
    power_B2_meas = simulate_photodetector(power_B2_ideal);
    power_C1_meas = simulate_photodetector(power_C1_ideal);
    power_C2_meas = simulate_photodetector(power_C2_ideal);
    
    % 3. Calculate measured Power Ratios (PR)
    P_total_out_meas = power_C1_meas + power_C2_meas;
    if P_total_out_meas == 0, P_total_out_meas = 1e-9; end
    
    PR_B_meas = power_B2_meas / P_total_out_meas;
    PR_C_meas = power_C1_meas / P_total_out_meas;
    
    % Store history
    phi_history(i) = phi_rad;
    theta_history(i) = theta_rad;
    PR_B_history(i) = PR_B_meas;
    PR_C_history(i) = PR_C_meas;
    
    % --- Independent Control Loops (UNCHANGED) ---
    error_B = PR_B_meas - PR_B_target;
    phi_rad = phi_rad - k_phi * (deriv_sign_B_target * error_B) * dt;
    
    error_C = PR_C_meas - PR_C_target;
    theta_rad = theta_rad - k_theta * (deriv_sign_C_target * error_C) * dt;
end

%% --- Plotting Results ---
figure('Position', [100, 100, 1000, 600]);

% Plot Power Ratios vs. Time
subplot(2, 1, 1);
plot(time_vec, PR_B_history, 'r-', 'LineWidth', 1.5);
hold on;
plot(time_vec, PR_C_history, 'b-', 'LineWidth', 1.5);
yline(PR_B_target, 'r--', 'Label', 'Target PR(B)');
yline(PR_C_target, 'b--', 'Label', 'Target PR(C)');
title('Non-Ideal MZI Power Ratios vs. Time');
xlabel('Time (s)');
ylabel('Power Ratio (PR)');
legend('Measured PR(B)', 'Measured PR(C)');
grid on;
ylim([0 1]);

% Plot Phase Shifts vs. Time
subplot(2, 1, 2);
plot(time_vec, phi_history / pi, 'r-', 'LineWidth', 1.5);
hold on;
plot(time_vec, theta_history / pi, 'b-', 'LineWidth', 1.5);
final_phi_val = phi_history(end);
final_theta_val = theta_history(end);
yline(final_phi_val/pi, 'r:', 'LineWidth', 2, 'Label', sprintf('Final \\phi = %.2f\\pi', final_phi_val/pi));
yline(final_theta_val/pi, 'b:', 'LineWidth', 2, 'Label', sprintf('Final \\theta = %.2f\\pi', final_theta_val/pi));
title('Controller Phase Shifts for Non-Ideal MZI');
xlabel('Time (s)');
ylabel('Phase (\times\pi rad)');
legend('Controlled \phi', 'Controlled \theta');
grid on;