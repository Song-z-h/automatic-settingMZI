function T_ps = PhaseShifter_topArm(phase, loss_dB)
    % phase can be expressed in radians (es. pi/2)
    % loss_dB rappresents the phaseshifter's loss
    alpha = 10^(-loss_dB / 20);
    T_ps = [exp(-1i*phase) * alpha, 0; 0, 1]; % Phase shift on the top arm in paper
end