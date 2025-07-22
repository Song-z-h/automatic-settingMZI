function params = generateMZIparams()
% Generate random parameters simulating fabrication and environmental variations
% Output: struct 'params' containing MZI imperfections

    %% Directional Coupler
    params.epsilon = 0.01 * randn();                   % Coupler imbalance
    params.loss_dc_dB = 0.3 + 0.1 * randn();           % Coupler loss

    %% Phase Shifters
    params.loss_top_dB = 1.0 + 0.2 * randn();          % Top arm phase shifter loss
    params.loss_bottom_dB = 0.8 + 0.2 * randn();       % Bottom arm phase shifter loss

    %% Arm Propagation Loss Imbalance
    params.alpha_top = 10^(-0.5 * rand() / 20);        % Up to 0.5 dB extra loss
    params.alpha_bottom = 10^(-0.8 * rand() / 20);     % Up to 0.8 dB extra loss

    %% Phase Values (with noise)
    desired_top_phase = pi/2;                          % For example, π/2
    desired_bottom_phase = 0;                          % Can be zero or other
    phase_noise_std = 0.05;                            % ~3° phase noise

    params.phase_top = desired_top_phase + phase_noise_std * randn();
    params.phase_bottom = desired_bottom_phase + phase_noise_std * randn();

    %% Thermal Drift Example (optional)
    T0 = 25;                                           % Base temperature (°C)
    T = T0 + 2 * sin(2*pi*rand());                     % Thermal variation
    drift_rate = pi/10;                                % rad/°C
    params.thermal_drift = drift_rate * (T - T0);

end
