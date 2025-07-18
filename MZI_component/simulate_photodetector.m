function measured_power = simulate_photodetector(optical_power)
    % Simulates a transparent photodetector measurement.
    % Based on values from the paper (Fig 3b).
    %
    % Input:
    %   optical_power - Ideal optical power in the waveguide (in mW).
    %
    % Output:
    %   measured_power - The power value as determined by the noisy measurement.

    % Detector characteristics from the paper
    R_responsivity = 18e-6; % 18 nA/mW = 18e-6 A/mW
    I_dark = 30e-12;       % 30 pA dark current
    
    % Simulate electronic noise (e.g., a small random value)
    % The magnitude of noise determines the precision of the system.
    noise_std_dev = 5e-12; % 5 pA standard deviation for noise
    I_noise = noise_std_dev * randn();

    % 1. Convert optical power to photocurrent
    I_photo = optical_power * R_responsivity;

    % 2. Add noise and subtract dark current (as per the paper's method)
    I_measured_total = I_photo + I_dark + I_noise;
    I_corrected = I_measured_total - I_dark;

    % 3. Convert corrected current back to a power reading
    measured_power = I_corrected / R_responsivity;
    
    % Ensure power cannot be negative due to noise
    if measured_power < 0
        measured_power = 0;
    end
end