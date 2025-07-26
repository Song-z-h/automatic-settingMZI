clear all; clc; close all;

%% Parameters
epsilons = -0.49 : 0.02 : 0.49;   % Sweep epsilon
n_eps = length(epsilons);

n_theta = 100;
n_phi = 100;
theta_vals = linspace(0, pi/2, n_theta);     % Controls power ratio
phi_vals = linspace(-pi, pi, n_phi);         % Controls phase difference

%% Prepare Figures
fig1 = figure('Name', 'Phase Error Animation');
fig2 = figure('Name', 'Power Error Animation');

for e = 1:n_eps
    epsilon = epsilons(e);

    % Prepare error maps
    phase_error_map = zeros(n_theta, n_phi);
    power_error_map = zeros(n_theta, n_phi);

    % Coupler matrices
    T_dc_ideal = DirectionalCouplers(0);
    T_dc_actual = DirectionalCouplers(epsilon);

    % Sweep input states
    for it = 1:n_theta
        for ip = 1:n_phi
            theta = theta_vals(it);
            phi = phi_vals(ip);

            % Normalized input state
            Ein = [cos(theta); exp(1i * phi) * sin(theta)];

            % Ideal output
            E_out_ideal = T_dc_ideal * Ein;
            prc_ideal = abs(E_out_ideal(1))^2;
            phase_true = angle(E_out_ideal(1)) - angle(E_out_ideal(2));

            % Actual output
            E_out_actual = T_dc_actual * Ein;
            prc_measured = abs(E_out_actual(1))^2;
            phase_measured = angle(E_out_actual(1)) - angle(E_out_actual(2));

            % Errors
            phase_error_map(it, ip) = abs(phase_measured - phase_true);
            power_error_map(it, ip) = abs(prc_measured - prc_ideal);
        end
    end

    %% Plot Phase Error Heatmap
    figure(fig1);
    clf;
    imagesc(phi_vals, theta_vals, phase_error_map);
    set(gca, 'YDir', 'normal');
    xlabel('Input Phase Difference φ (deg)');
    ylabel('Input Power Ratio Angle θ (deg)');
    title(sprintf('Phase Error [rad] – ε = %.2f', epsilon), 'FontSize', 14);
    colorbar;
    colormap jet;
    xticks([-pi -pi/2 0 pi/2 pi]);
    xticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'});
    yticks([0 pi/6 pi/4 pi/3 pi/2]);
    yticklabels({'0','\pi/6','\pi/4','\pi/3','\pi/2'});
    drawnow;

    %% Plot Power Error Heatmap
    figure(fig2);
    clf;
    imagesc(phi_vals, theta_vals, power_error_map);
    set(gca, 'YDir', 'normal');
    xlabel('Input Phase Difference φ (deg)');
    ylabel('Input Power Ratio Angle θ (deg)');
    title(sprintf('Power Error – ε = %.2f', epsilon), 'FontSize', 14);
    xticks([-pi -pi/2 0 pi/2 pi]);
    xticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'});
    yticks([0 pi/6 pi/4 pi/3 pi/2]);
    yticklabels({'0','\pi/6','\pi/4','\pi/3','\pi/2'});
    colorbar;
    colormap turbo;
    
    drawnow;

    pause(0.1);  % Adjust speed of animation
end
