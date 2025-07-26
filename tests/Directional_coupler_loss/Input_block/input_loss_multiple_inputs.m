clear all; clc; close all;

imperfections.loss_ps = 0.00;
epsilons = -0.49 : 0.005 : 0.49;
n_eps = length(epsilons);
psi = 0.5 *pi %4.7144;

% Define multiple input states
E_inputs = {
    [1; 0], 'Input = [1; 0]';
    [0; 1], 'Input = [0; 1]';
    [1; 1]/sqrt(2), 'Input = [1; 1]/√2';
    [1; 1i]/sqrt(2), 'Input = [1; 1i]/√2'
};
n_inputs = size(E_inputs, 1);

% Create figures
figure('Name', 'Phase Error vs \epsilon');
tiledlayout(n_inputs, 1);

figure('Name', 'Power Error vs \epsilon');
tiledlayout(n_inputs, 1);

% Loop over different input states
for j = 1:n_inputs
    Ein = E_inputs{j,1};
    label = E_inputs{j,2};

    power_measured = zeros(1, n_eps);
    phase_measured = zeros(1, n_eps);

    % Ideal output
    imperfections.epsilon = 0.0;
    [~, ~, E_out_ideal] = mzi_model_input(psi, Ein, imperfections);
    phase_true = angle(E_out_ideal(1)) - angle(E_out_ideal(2));
    power_true = abs(E_out_ideal(1))^2;

    % Loop over epsilon values
    for i = 1:n_eps
        imperfections.epsilon = epsilons(i);
        [~, ~, VC] = mzi_model_input(psi, Ein, imperfections);

        power_measured(i) = abs(VC(1))^2;
        phase_measured(i) = angle(VC(1)) - angle(VC(2));
    end

    % Compute errors
    phase_error = abs(phase_measured - phase_true);
    power_error = abs(power_measured - power_true);

    % Plot phase error
    figure(1);
    nexttile;
    plot(epsilons, phase_error, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]);
    title(['Phase Error – ', label], 'FontSize', 12);
    xlabel('\epsilon', 'FontSize', 11);
    ylabel('Phase Error', 'FontSize', 11);
    grid on;

    % Plot power error
    figure(2);
    nexttile;
    plot(epsilons, power_error, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980]);
    title(['Power Error – ', label], 'FontSize', 12);
    xlabel('\epsilon', 'FontSize', 11);
    ylabel('Power Error', 'FontSize', 11);
    grid on;
end
