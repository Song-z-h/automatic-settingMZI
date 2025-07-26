clear all; clc; close all;

imperfections.loss_ps = 0.00;
epsilons = -0.49 : 0.01 : 0.49;
psis = linspace(0, 2*pi, 300);

n_eps = length(epsilons);
n_psi = length(psis);

% Define multiple input states
E_inputs = {
    [1; 0], 'Input = [1; 0]';
    [0; 1], 'Input = [0; 1]';
    [1; 1]/sqrt(2), 'Input = [1; 1]/√2';
    [1; 1i]/sqrt(2), 'Input = [1; 1i]/√2'
};
n_inputs = size(E_inputs, 1);

for j = 1:n_inputs
    Ein = E_inputs{j,1};
    label = E_inputs{j,2};

    phase_error_map = zeros(n_psi, n_eps);
    power_error_map = zeros(n_psi, n_eps);

    for k = 1:n_psi
        psi = psis(k);

        % Ideal output at epsilon = 0
        imperfections.epsilon = 0.0;
        [~, ~, E_out_ideal] = mzi_model_input(psi, Ein, imperfections);
        phase_true = angle(E_out_ideal(1)) - angle(E_out_ideal(2));
        power_true = abs(E_out_ideal(1))^2;

        for i = 1:n_eps
            imperfections.epsilon = epsilons(i);
            [~, ~, E_out] = mzi_model_input(psi, Ein, imperfections);

            power_measured = abs(E_out(1))^2;
            phase_measured = angle(E_out(1)) - angle(E_out(2));

            phase_error_map(k,i) = abs(phase_measured - phase_true);
            power_error_map(k,i) = abs(power_measured - power_true);
        end
    end

    % Plot Phase Error Heatmap
    figure;
    imagesc(epsilons, psis, phase_error_map);
    colorbar;
    xlabel('\epsilon', 'FontSize', 12);
    ylabel('\psi (rad)', 'FontSize', 12);
    title(['Phase  – ', label], 'FontSize', 14, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');

    % Plot Power Error Heatmap
    figure;
    imagesc(epsilons, psis, power_error_map);
    colorbar;
    xlabel('\epsilon', 'FontSize', 12);
    ylabel('\psi (rad)', 'FontSize', 12);
    title(['Power – ', label], 'FontSize', 14, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');
end
