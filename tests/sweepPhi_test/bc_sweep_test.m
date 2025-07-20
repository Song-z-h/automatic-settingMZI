% Clear workspace and close figures
clear;
clc;
close all;

% --- 1. MZI Physical Model and Control Loop Logic ---
% Define the functions at the end of the script file.
% The logic is identical to the previous explanation.

VA = [1/sqrt(2); 1/sqrt(2)];
%% 

% --- 2. Run the Sweep Simulation ---
p_phi_sweep = linspace(0, 50, 30);

% Pre-allocate arrays for efficiency
p_theta_controlled = zeros(size(p_phi_sweep));
pr_c_results = zeros(size(p_phi_sweep));
pr_b_results = zeros(size(p_phi_sweep));
phase_chic_results = zeros(size(p_phi_sweep));

imperfections.epsilon = 0.00;
imperfections.loss_ps = 0.00;
% Loop through each power setting for the Phi heater
for i = 1:length(p_phi_sweep)
    p_phi_val = get_phase_from_power(p_phi_sweep(i));

    % Feedback control for θ
    theta = 0; % initial guess
    delta = 1;
    max_iter = 100;
    iter = 0;
    pr_target = 0.5; %the target of pr(C) that we want the controller to set it at 50%
    dpr_target = 1;

    %get output from b and pr(b)
    [~, powerb2, outb] = mzi_model_bottomArm(p_phi_val, VA, imperfections);
    
    % compute theta of c
    while abs(delta) > 1e-4 && iter < max_iter
        iter = iter + 1;
        [theta, delta] = MZI_C(outb, pr_target, theta, imperfections, dpr_target);
    end

    % using the controlled data to perform the mzi again
    [powerc1, ~, VC] = mzi_model_topArm(theta, outb, imperfections); 

    pr_c_results(i) = powerc1;
    pr_b_results(i) = powerb2;
    
    % For each step, the "control loop" finds the correct p_theta
    p_theta_controlled(i) = get_power_from_phase(theta);


    %get the phase differenct at output Xc
    Xc = angle(VC(1)) - angle(VC(2));
        chi_C = mod(Xc, 2*pi);  % Wrap to [0, 2π]
    phase_chic_results(i) = chi_C;

end

% --- 3. Plot the Results ---
figure('Name', 'MATLAB Simulation of MZI Control Loop');

% Subplot (a) - Power Ratios
subplot(1, 2, 1);
hold on;
plot(p_phi_sweep, pr_c_results, 'b-', 'LineWidth', 2, 'DisplayName', 'PR(C)');
plot(p_phi_sweep, pr_b_results, 'r-', 'LineWidth', 2, 'DisplayName', 'PR(B)');
hold off;
xlabel('Heater Φ power [mW]');
ylabel('Power Ratio (PR)');
title('(a) Simulated Power Ratios with PR(C) Control Loop Active');
grid on;
ylim([-0.1, 1.1]);
legend('show', 'Location', 'best');
box on;

% Subplot (b) - Phase and Heater Theta Power
subplot(1, 2, 2);
yyaxis left; % Use left y-axis for Phase chi_c
plot(p_phi_sweep, phase_chic_results, 'b-', 'LineWidth', 2, 'DisplayName', 'Phase χc [rad]');
ylabel('Phase χc [rad]');
ylim([0, 2*pi]);
yticks([0, pi/2, pi, 3*pi/2, 2*pi]);
yticklabels({'0', '\pi/2', '\pi', '3\pi/2', '2\pi'});

yyaxis right; % Use right y-axis for Heater theta power
plot(p_phi_sweep, p_theta_controlled, 'r-', 'LineWidth', 2, 'DisplayName', 'Heater θ power [mW]');
ylabel('Heater θ power [mW]');
% Set y-axis limits and ticks to match the image approximately
ylim([0, 70]); % Adjusted based on the image
yticks([10, 20, 30, 40, 50, 60, 70]);

xlabel('Heater Φ power [mW]');
title('(b) Phase and Heater Theta Power');
grid on;
legend('show', 'Location', 'best');
box on;


% --- Function Definitions ---
% In MATLAB, functions are typically defined at the end of the script.

function phase = get_phase_from_power(power_mw)
    % Converts heater power (mW) to phase (radians). 50mW = 2*pi.
    phase = (pi * 2.0 / 50.0) * power_mw;
end

function power_mw = get_power_from_phase(phase)
    % Converts heater power (mW) to phase (radians). 50mW = 2*pi.
     power_mw = phase * (70.0 / (2.0 * pi));
end
