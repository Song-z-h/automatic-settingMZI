clear all; clc; close all;

% Constants
epsilons = -0.2 : 0.005 : 0.2;   % Coupler imbalance
psis = linspace(0, 2*pi, 300);   % Phase shifter values

Ein = [-0.4990 + 0.5000i; 
        0.5000 - 0.5010i];
loss_dB = 0;

% Ideal coupler and reference output
T_dc_ideal = DirectionalCouplers(0);
T_output_ref = zeros(2, length(psis));
for j = 1:length(psis)
    T_ps_ideal = PhaseShifter_topArm(psis(j), loss_dB);
    T_output_ideal = T_ps_ideal * T_dc_ideal * Ein;
    T_output_ref(:, j) = T_output_ideal;
end
power_true = abs(T_output_ref(1, :)).^2;
phase_true = angle(T_output_ref(1, :)) - angle(T_output_ref(2, :));

% Preallocate error matrices
phase_error = zeros(length(psis), length(epsilons));
power_error = zeros(length(psis), length(epsilons));

% Sweep over epsilon and psi
for i = 1:length(epsilons)
    epsilon = epsilons(i);
    T_dc = DirectionalCouplers(epsilon);
    
    for j = 1:length(psis)
        psi = psis(j);
        T_ps = PhaseShifter_topArm(psi, loss_dB);
        VC = T_ps * T_dc * Ein;
        
        phase_diff = angle(VC(1)) - angle(VC(2));
        powerc1 = abs(VC(1)).^2;

        % Compute error against reference
        phase_error(j, i) = abs(wrapToPi(phase_diff - phase_true(j)));
        power_error(j, i) = abs(powerc1 - power_true(j));
    end
end

% Plot Phase Error Heatmap
figure;
imagesc(epsilons, psis, phase_error);
set(gca, 'YDir', 'normal');
xlabel('\epsilon');
ylabel('\psi (rad)');
title('Phase Error vs \epsilon and \psi');
colorbar;
colormap turbo;

% Plot Power Error Heatmap
figure;
imagesc(epsilons, psis, power_error);
set(gca, 'YDir', 'normal');
xlabel('\epsilon');
ylabel('\psi (rad)');
title('Power Error vs \epsilon and \psi');
colorbar;
colormap turbo;
