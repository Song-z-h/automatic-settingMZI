function T_ps = PhaseShifter(phase, loss_dB)
  alpha = 10^(-loss_dB / 20);
  T_ps = [exp(1i*phase) * alpha, 0; 0, 1]; % Phase shift on one arm
end