   function [VC, PR_C, chi_C] = simulate_MZI(phi, theta)
    % INPUT: phase shifts in radians
    % OUTPUT:
    %   VC    : output vector (complex)
    %   PR_C  : output power ratio (amplitude^2 of 1st component)
    %   chi_C : phase difference between outputs (in radians)

    % Define the MZI transmission matrix (from Eq. 1 in the paper)
    TMZI = -1j * exp(-1j * theta / 2) * ...
        [sin(theta / 2), cos(theta / 2) * exp(-1j * phi);
         cos(theta / 2), -sin(theta / 2) * exp(-1j * phi)]
    % Input vector (equal power, in-phase)
    VA = [1/sqrt(2); 1/sqrt(2)];

    % Compute output vector
    VC = TMZI * VA;

    % Output power ratio: proportion of output in 1st component
    PR_C = abs(VC(1))^2;

    % Phase difference between outputs
    delta = angle(VC(1)) - angle(VC(2));
        chi_C = mod(delta, 2*pi);  % Wrap to [0, 2π]

end
