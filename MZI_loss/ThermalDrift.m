function delta_phi = ThermalDrift(t, T0, drift_rate)
    % T0 is initial temperature, drift_rate is phase change per °C
    T = T0 + 0.1*sin(2*pi*t/500);  % example: sinusoidal variation
    delta_phi = drift_rate * (T - T0);
end
