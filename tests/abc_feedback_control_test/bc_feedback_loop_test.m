clear all;

% === TARGET VALUES ===
phi_target = 0.2 * pi;     % ≤ pi/2
theta_target = 0.15 * pi;
dpr_target = -1;
dpr_target2 = -1;

% === INITIAL CONDITIONS ===
phi = 0;
theta = 0;
VA = [1/sqrt(2); 1/sqrt(2)];
h = 25e-3;  % Time step
delta_target = 1e-4;

% === IMPERFECTIONS ===
imperfections.epsilon = 0.00;
imperfections.loss_ps = 0;

% === GROUND TRUTH OUTPUT ===
[~, PR_C_target, PR_B_target, ~] = simulate_MZI(phi_target, theta_target, VA);
[~, ~, outB_target] = mzi_model_bottomArm(phi_target, VA, imperfections);
[~, ~, outC_target] = mzi_model_topArm(theta_target, outB_target, imperfections);

% === PREP FOR TRACKING ===
phi_history = [];
theta_history = [];
PR_B_history = [];
PR_C_history = [];
fidelity_history = [];
time_vec = [];
t = 0;

% === GROUND TRUTH UNITARY ===
Uid = get_tmzi(phi_target, theta_target);

% === CONTROL PHI ===
delta1 = 50;
while abs(delta1) > delta_target
    [phi ,delta1] = MZI_B(VA, PR_B_target, phi, imperfections, dpr_target);
    
    [~, PR_C, PR_B, ~] = simulate_MZI(phi, theta, VA);
    U_current = get_tmzi(phi, theta);
    fidelity = calculate_unitary_fidelity(U_current, Uid);

    % Record
    phi_history(end+1) = phi;
    theta_history(end+1) = theta;
    PR_B_history(end+1) = PR_B;
    PR_C_history(end+1) = PR_C;
    fidelity_history(end+1) = fidelity;
    t = t + h;
    time_vec(end+1) = t;
end

% === CONTROL THETA ===
delta2 = 50;
[~, ~, outB_measured] = mzi_model_bottomArm(phi, VA, imperfections);

while abs(delta2) > delta_target
    [theta, delta2] = MZI_C(outB_measured, PR_C_target, theta, imperfections, dpr_target2);
    
    [~, PR_C, PR_B, ~] = simulate_MZI(phi, theta, VA);
    U_current = get_tmzi(phi, theta);
    fidelity = calculate_unitary_fidelity(U_current, Uid);

    % Record
    phi_history(end+1) = phi;
    theta_history(end+1) = theta;
    PR_B_history(end+1) = PR_B;
    PR_C_history(end+1) = PR_C;
    fidelity_history(end+1) = fidelity;
    t = t + h;
    time_vec(end+1) = t;
end

% === FINAL OUTPUT ===
[~, ~, outB_measured] = mzi_model_bottomArm(phi, VA, imperfections);
[~, ~, outC_measured] = mzi_model_topArm(theta, outB_measured, imperfections);

outC_measured
outC_target

% === FINAL UNITARY & FIDELITY ===
U2 = get_tmzi(phi, theta);
fidelity = calculate_unitary_fidelity(U2, Uid);
fprintf('The fidelity between Uid and U2 is: %.10f\n', fidelity);

% === PLOT RESULTS ===
figure('Position', [100, 100, 1200, 600]);

subplot(3,1,1);
plot(time_vec, PR_B_history, 'r-', 'LineWidth', 1.5);
hold on;
plot(time_vec, PR_C_history, 'b-', 'LineWidth', 1.5);
yline(PR_B_target, 'r--', 'Target PR(B)');
yline(PR_C_target, 'b--', 'Target PR(C)');
xlabel('Time (s)');
ylabel('Power Ratio');
title('PR(B) and PR(C) vs Time');
legend('PR(B)', 'PR(C)');
grid on;
ylim([0 1]);

subplot(3,1,2);
plot(time_vec, phi_history / pi, 'r-', 'LineWidth', 1.5);
hold on;
plot(time_vec, theta_history / pi, 'b-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Phase (\times\pi rad)');
title('Phase Convergence of \phi and \theta');
legend('\phi', '\theta');
grid on;

subplot(3,1,3);
plot(time_vec, fidelity_history, 'k-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Fidelity');
title('Fidelity between U_{ideal} and U_{measured}');
ylim([0 1.05]);
grid on;

% === HELPER FUNCTIONS ===

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
