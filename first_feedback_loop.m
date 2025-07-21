PR_target=0.5;
V_heater=0;
psi=0;
delta=50;
it=0;
while abs(delta)>0.001 & it<3000
[V_heater,delta] = MZI_a(PR_target,V_heater,psi,-1);
psi=V_heater
it=it+1;
end

%% Checking system effectiveness for the whole range of PR_A
pr_measured=[];
delta_=[];
for target=0:0.001:1
PR_target=0.5;
V_heater=0;
psi=0;
delta=50;
it=0;

derivative= sign(rand() - 0.5);

while abs(delta)>0.001 & it<100000

[psi,delta] = MZI_a(target,V_heater,psi,derivative);
%psi=V_heater;
V_heater=psi;
it=it+1;
end
delta_=[delta_;delta];
pr_measured=[pr_measured;delta+target];
end
target=0:0.001:1;
sigma_acc=sqrt(sum((pr_measured-target').^2));
sigma_prec=sqrt(sum((pr_measured-mean(target)).^2))
%res=log2(1/sigma)

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
plot(0:0.001:1,pr_measured-[0:0.001:1]')
xlabel('PR_A', 'FontSize', 12);
ylabel('Error', 'FontSize', 12);
 
grid on


%% Checking Phase Control Loop
PRC_target=0.5;
V_heater=0;
psi=0;
delta=50;
it=0;

derivative= sign(rand() - 0.5);

while abs(delta)>0.001 & it<100000
 EB = [1/sqrt(2);1/sqrt(2)];
 PR_B=0.5+EB(1)*EB(2)*sin(phi);
[phi,delta] = MZI_b(PR,phi,derivative);
[theta,phi,delta] = MZI_c(PRC_target,theta,derivative);
%psi=V_heater;
V_heater=psi;
it=it+1;
end
delta_=[delta_;delta];
pr_measured=[pr_measured;delta+target];
