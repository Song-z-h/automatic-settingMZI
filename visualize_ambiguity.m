
phi_vals = linspace(0, 2*pi, 100);
theta_vals = linspace(0, 2*pi, 100);

[Phi, Theta] = meshgrid(phi_vals, theta_vals);
PR_C = zeros(size(Phi));
Chi_C = zeros(size(Phi));

for i = 1:length(phi_vals)
    for j = 1:length(theta_vals)
        [~, PR_C(j,i), Chi_C(j,i)] = simulate_MZI(phi_vals(i), theta_vals(j));
    end
end

% Plot power ratio
figure;
imagesc(phi_vals, theta_vals, PR_C);
set(gca, 'YDir', 'normal');
xlabel('\phi [rad]'); ylabel('\theta [rad]');
title('Output Power Ratio PR(C)');
colorbar;
xticks([0, pi/2, pi, 3*pi/2, 2*pi]);
xticklabels({'0', '\pi/2', '\pi', '3\pi/2', '2\pi'});
yticks([0, pi/2, pi, 3*pi/2, 2*pi]);
yticklabels({'0', '\pi/2', '\pi', '3\pi/2', '2\pi'});

% Plot phase difference
figure;
imagesc(phi_vals, theta_vals, Chi_C);
set(gca, 'YDir', 'normal');
xlabel('\phi [rad]'); ylabel('\theta [rad]');
title('Phase Difference \chi_C [rad]');
colorbar;

cb = colorbar('Location', 'eastoutside');  % Ensure it's placed beside
cb.Ticks = [0, pi/2, pi, 3*pi/2, 2*pi];
cb.TickLabels = {'0', '0.5\pi', '\pi', '1.5\pi', '2\pi'};

axis tight;  % Fit the axes tightly to data
yticks([0, pi/2, pi, 3*pi/2, 2*pi]);
yticklabels({'0', '\pi/2', '\pi', '3\pi/2', '2\pi'});
xticks([0, pi/2, pi, 3*pi/2, 2*pi]);
xticklabels({'0', '\pi/2', '\pi', '3\pi/2', '2\pi'});
