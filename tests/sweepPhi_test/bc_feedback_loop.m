clear all;
% Immagine that I want to do this arbitrary computation
phi_target =  0.2 * pi;  % this value cant be more than pi/2
theta_target = 0.15 * pi;
dpr_target = -1;
dpr_target2 = -1;

%current phase shifters are random
phi = 0;
theta = 0;

%the correct output in normal MZI
[VC, PR_C,PR_B, chi_C] = simulate_MZI(phi_target, theta_target);

%loss 
imperfections.epsilon = 0.00; % no more than 0.5
imperfections.loss_ps = 0; % can be more than 1, as long as the program stops
% time inteval
h = 25e-3;

%input after the input mzi
VA = [1/sqrt(2); 1/sqrt(2)];

[~, ~, outB_target] = mzi_model_bottomArm(phi_target, VA, imperfections);
[~, ~, outC_target] = mzi_model_topArm(theta_target, outB_target, imperfections);

delta1 = 50;
delta_target = 0.0001;
while abs(delta1) > delta_target
[phi ,delta1] = MZI_B(VA, PR_B, phi, imperfections, dpr_target);
end


delta2 = 50;

[~, ~, outB_measured] = mzi_model_bottomArm(phi, VA, imperfections);
%add max iteration
while abs(delta2) > delta_target
     [theta, delta2] = MZI_C(outB_measured, PR_C, theta, imperfections, dpr_target2);
end

[~, ~, outC_measured] = mzi_model_topArm(theta, outB_measured, imperfections); 

outC_measured
outC_target

%CALCULATE FIDELITY
Uid = get_tmzi(phi_target, theta_target);
U2 = get_tmzi(phi, theta);
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


function TMZI = get_tmzi(phi, theta)
    TMZI = -1j * exp(-1j * theta / 2) * ...
        [sin(theta / 2), cos(theta / 2) * exp(-1j * phi);
         cos(theta / 2), -sin(theta / 2) * exp(-1j * phi)];
end