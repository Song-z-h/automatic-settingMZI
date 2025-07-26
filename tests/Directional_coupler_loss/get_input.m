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
