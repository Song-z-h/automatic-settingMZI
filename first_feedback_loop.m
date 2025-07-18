PR_target=0.5;
V_heater=0;
psi=0;
delta=50;
it=0;
while abs(delta)>0.001 | it>10
[V_heater,delta] = MZI_a(PR_target,V_heater,psi);
psi=V_heater
it=it+1;
end

%% Checking system effectiveness for the whole range of PR_A
pr_measured=[];
for target=0:0.001:1
PR_target=0.5;
V_heater=0;
psi=0;
delta=50;
it=0;
while abs(delta)>0.001 & it<3000
[V_heater,delta] = MZI_a(target,V_heater,psi);
psi=V_heater;
it=it+1;
end
pr_measured=[pr_measured;delta+target];
end
target=0:0.01:1;
sigma_acc=sqrt(sum((pr_measured-target').^2));
sigma_prec=sqrt(sum((pr_measured-mean(target)).^2))
res=log2(1/sigma)

%%
figure;
plot(0:0.001:1,pr_measured, 'LineWidth', 2, ...        
    'Color', [0, 0.5, 0.8], ...  
    'Marker', 'o', ...           
    'MarkerSize', 6, ...         
    'MarkerFaceColor', 'red', 'MarkerIndices', 1:100:length(pr_measured));  
title("Measured vs Target PR_A", 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Target PR_A', 'FontSize', 12);
ylabel('Measured PR_A', 'FontSize', 12);
grid on

% Optional: Customize axes font
set(gca, 'FontSize', 11, 'LineWidth', 1);
figure;
plot(0:0.001:1,pr_measured-[0:0.001:1]'-pr_measured)
xlabel('PR_A', 'FontSize', 12);
ylabel('Error', 'FontSize', 12);
ylim([-9.88e-4, 1.004e-3]);   
grid on

