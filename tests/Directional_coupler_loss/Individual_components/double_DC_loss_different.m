clear all; clc; close all;

imperfections.loss_ps = 0.00;
Ein = [-0.4990 + 0.5000i;
        0.5000 - 0.5010i];
Ein = [1; -1i]/sqrt(2);

% Sweep two separate epsilon values
epsilons = -0.49 : 0.01 : 0.49;
n_eps = length(epsilons);

% Preallocate error matrices
power_error = zeros(n_eps, n_eps);
phase_error = zeros(n_eps, n_eps);

% Ideal output (no epsilon error)
T_dc_ideal1 = DirectionalCouplers(0);
T_dc_ideal2 = DirectionalCouplers(0);
T_output_ideal = T_dc_ideal2 * T_dc_ideal1 * Ein;
prc_ideal = abs(T_output_ideal(1))^2;
phase_true = angle(T_output_ideal(1)) - angle(T_output_ideal(2));

% Sweep over epsilon1 (for DC1) and epsilon2 (for DC2)
for i = 1:n_eps
    for j = 1:n_eps
        eps1 = epsilons(i);  % epsilon for DC1
        eps2 = epsilons(j);  % epsilon for DC2

        T_dc1 = DirectionalCouplers(0);
        T_dc2 = DirectionalCouplers(eps2);

        VC = T_dc2 * T_dc1 * Ein;
        powerc1 = abs(VC(1))^2;
        phase_meas = angle(VC(1)) - angle(VC(2));

        power_error(j,i) = abs(powerc1 - prc_ideal);
        phase_error(j,i) = abs(phase_meas - phase_true);
    end
end

%% Plot Power Error Surface
figure;
imagesc(epsilons, epsilons, power_error);
xlabel('\epsilon_1 (DC1)', 'FontSize', 12);
ylabel('\epsilon_2 (DC2)', 'FontSize', 12);
title('Power Error Map', 'FontSize', 14, 'FontWeight', 'bold');
colorbar;
set(gca, 'YDir', 'normal');
colormap jet;

%% Plot Phase Error Surface
figure;
imagesc(epsilons, epsilons, phase_error);
xlabel('\epsilon_1 (DC1)', 'FontSize', 12);
ylabel('\epsilon_2 (DC2)', 'FontSize', 12);
title('Phase Error Map', 'FontSize', 14, 'FontWeight', 'bold');
colorbar;
set(gca, 'YDir', 'normal');
colormap turbo;
