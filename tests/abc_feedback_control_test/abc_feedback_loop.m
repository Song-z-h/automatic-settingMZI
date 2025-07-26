clear; clc; close all;
% Immagine that I want to do this arbitrary computation
phi_target =  0.2 * pi;  
theta_target = 0.15 * pi;
psi_target = 0.5 * pi;
dpr_target_input = -1;
dpr_target = -1;
dpr_target2 = -1;

%loss
imperfections.epsilon = 0.0;
imperfections.loss_ps = 0.0;

% time inteval
h = 25e-3;

%current phase shifters are random
phi = 0;
theta = 0;
psi = 0;

%the idea model is
VA = [1/sqrt(2); 1/sqrt(2)];
[~, ~, outB_target] = mzi_model_bottomArm(phi_target, VA, imperfections);
[~, ~, outC_target] = mzi_model_topArm(theta_target, outB_target, imperfections);
%the correct output in normal MZI
[VC, PR_C,PR_B, chi_C] = simulate_MZI(phi_target, theta_target, VA);

%we need to have our input first
E_in = [1; 0];
delta_in = 1;
delta_target = 0.0001;
PR_A = 0.5;
%loop a
while abs(delta_in) > delta_target
[psi ,delta_in] = MZI_A(E_in, PR_A, psi, imperfections, dpr_target_input);
end
[p1, p2, VA_measured] = mzi_model_input(psi, E_in, imperfections);

VA_measured
VA
fidelity_input = abs(VA' * VA_measured)^2;
fprintf('The fidelity between input vector and looped input is: %.10f\n', fidelity_input);
%even the input vector has fidelity and power ratio equal to our ideal input
%But the phase is different, therefore, it changes the final result..

% Compute relative phase

rel_phase_meas = angle(VA_measured(1)) - angle(VA_measured(2));
rel_phase_target = angle(VA(1)) - angle(VA(2));

fprintf('Measured relative phase: %.4f rad\n', rel_phase_meas);
fprintf('Target relative phase:   %.4f rad\n', rel_phase_target);
%abs(VA)
%abs(VA_measured)
%loop b
delta1 = 50;
while abs(delta1) > delta_target
[phi ,delta1] = MZI_B(VA_measured, PR_B, phi, imperfections, dpr_target);
end
[~, ~, outB_measured] = mzi_model_bottomArm(phi, VA_measured, imperfections);

%loop c
delta2 = 50;
while abs(delta2) > delta_target
     [theta, delta2] = MZI_C(outB_measured, PR_C, theta, imperfections, dpr_target2);
end
[~, ~, outC_measured] = mzi_model_topArm(theta, outB_measured, imperfections); 

outC_measured
outC_target

outC_measured = outC_measured / norm(outC_measured);
fidelity_output = abs(outC_target' * outC_measured)^2;
fprintf('The fidelity between measured final output and target output is: %.10f\n', fidelity_output);
%The result is different, but the fidelity is equal also for the output
amplitude_out_target = mean(abs(outC_target));
amplitude_out_measured = mean(abs(outC_measured));
fprintf('The amplitude of measured output is: %.10f\n', amplitude_out_measured);
fprintf('The amplitude of target output is: %.10f\n', amplitude_out_target);


%CALCULATE FIDELITY
Uid = get_tmzi(psi_target, phi_target, theta_target);
U2 = get_tmzi(psi, phi, theta);
% Calculate the fidelity
fidelity = calculate_unitary_fidelity(U2, Uid);
fprintf('The fidelity between Uid and U2 is: %.10f\n', fidelity);


function F = calculate_unitary_fidelity(U_actual, U_ideal)
    N = size(U_actual, 1);
    if size(U_actual, 2) ~= N || size(U_ideal, 1) ~= N || size(U_ideal, 2) ~= N
        error('Input matrices U_actual and U_ideal must be square and of the same dimension.');
    end
    numerator = abs(trace(U_actual' * U_ideal))^2;
    denominator = abs(sqrt(N * trace(U_ideal' * U_ideal)))^2;
    if denominator == 0
        F = 0;
        warning('Denominator is zero in fidelity calculation. Returning 0 fidelity.');
    else
        F = numerator / denominator;
    end
    F = min(1, max(0, F));
end


function TOUT = get_tmzi(psi, phi, theta)
    TMZI = -1j * exp(-1j * theta / 2) * ...
        [sin(theta / 2), cos(theta / 2) * exp(-1j * phi);
         cos(theta / 2), -sin(theta / 2) * exp(-1j * phi)];

    T_dc1 = DirectionalCouplers(0);
    T_dc2 = DirectionalCouplers(0);
    T_ps = PhaseShifter_topArm(psi, 0);

    % Field Propagation cascading each conponents
    T_input = T_dc2 * T_ps * T_dc1 ;
    TOUT = TMZI * T_input;
end