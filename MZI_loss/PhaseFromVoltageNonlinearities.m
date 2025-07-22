function phase = PhaseFromVoltageNonlinearities(V, a, b, sigma)
    phase = a*V + b*V.^2 + sigma*randn();  % sigma: noise std
end
