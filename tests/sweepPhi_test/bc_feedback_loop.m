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
imperfections.epsilon = 0.0;
imperfections.loss_ps = 0.0;
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
phi
[~, ~, outB_measured] = mzi_model_bottomArm(phi, VA, imperfections);

while abs(delta2) > delta_target
     [theta, delta2] = MZI_C(out, PR_C, theta, imperfections, dpr_target2);
end

[~, ~, outC_measured] = mzi_model_topArm(theta, out, imperfections); 

outC_measured
outC_target
