% Function to simulate a 4x4 Clements mesh of MZIs
% using the existing MZI_bc_block control loop.

function [U_total, VC_all, fidelity, output_intensities] = simulate_MZI_4_4(imperfections, U_target)

    % === Initialization ===
    num_ports = 4;
    E_in = eye(num_ports);  % 4 orthogonal inputs to test full unitary
    
    %to normalize E_in
   
    % Allocate output fields and control voltages
    E_out = zeros(num_ports);
    VC_all = cell(num_ports - 1, num_ports - 1);  % Up to (N-1)x(N-1) MZIs in a Clements mesh

    %[1, 0, 0, 0]  E(1)
    %[0, 1, 0, 0]  E(2)
    %[0, 0, 1, 0]
    %[0, 0, 0, 1 ]
    phi = 0;
    theta = pi;
    % === Loop through basis inputs to build the full unitary ===
    for k = 1:num_ports
        E = E_in(:, k);  % inject basis vector

        % === First Layer (MZI 1 & 2) ===
        [U1, VC1] = MZI_bc_block(E([1,2]), phi, theta, imperfections);
        E([1,2]) = U1 * E([1,2]);
        VC_all{1,1} = VC1;

        [U2, VC2] = MZI_bc_block(E([3,4]), phi, theta, imperfections);
        E([3,4]) = U2 * E([3,4]);
        VC_all{1,2} = VC2;

        % === Second Layer (MZI 3 & 4) ===
        [U3, VC3] = MZI_bc_block(E([2,3]), phi, theta, imperfections);
        E([2,3]) = U3 * E([2,3]);
        VC_all{2,1} = VC3;
        %this is the one in the middle

        [U4, VC4] = MZI_bc_block(E([1,2]), phi, theta, imperfections);
        E([1,2]) = U4 * E([1,2]);
        VC_all{2,2} = VC4;

        % === Third Layer (MZI 5) ===
        [U5, VC5] = MZI_bc_block(E([3,4]), phi, theta, imperfections);
        E([3,4]) = U5 * E([3,4]);
        VC_all{3,1} = VC5;

        % === Save output for current basis input ===
        E_out(:,k) = E;
    end

    % === Construct unitary ===
    U_total = E_out;

    % === Fidelity Calculation ===
    if nargin < 2
        U_target = eye(num_ports);  % Default: identity if not given
    end
    fidelity = abs(trace(U_target' * U_total))^2 / num_ports^2;

    % === Output intensities (assuming input = [1;0;0;0]) ===
    input_vector = [0.5; 0.5; 0.5; 0.5];
    output_vector = U_total * input_vector;
output_intensities = abs(output_vector).^2;
input_intensities = abs(input_vector).^2;

% === Plot ===
figure;
hold on;
% Output bars: solid blue
hOut = bar(output_intensities, 'FaceColor', [0, 0.45, 0.74], 'EdgeColor', 'none');

% Overlay red horizontal lines at input intensity levels
for i = 1:length(input_intensities)
    y = input_intensities(i);
    x = [i - 0.4, i + 0.4];  % Span within bar width
    plot(x, [y, y], 'r-', 'LineWidth', 2);
end

xlabel('Port Index');
ylabel('Optical Power');
title('Input vs Output Intensities');
legend(hOut, 'Output Intensities');

hold off;

fprintf("Fidelity with target unitary: %.4f\n", fidelity);
%fprintf('U_total =\n');
%disp(U_total);
fprintf("The total output power is: %.4f\n", sum(output_intensities));

end
