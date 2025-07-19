function T_ps = PhaseShifter_bottomArm(phase, loss_dB)
    % phase can be expressed in radians (es. pi/2)
    % loss_dB rappresents the phaseshifter's loss
    alpha = 10^(-loss_dB / 20);
    T_ps = [1, 0; 0, exp(-1i*phase) * alpha]; % Phase shift on the top arm in paper
end