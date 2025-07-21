clear all
i=1;
imperfections.epsilon = 0.00;
imperfections.loss_ps = 0.00;
Power_measured=[];
phase_measured=[];
VC_measured=[];
VC_true=[];
target_b=[];
target_c=[];
desired_phi=1.8*pi;
desired_theta=0.15*pi;
for derivative=-1:2:1
for target_a=0.2:0.2:1
    %target_b=0.2061;
    %target_c=[0.684; 0.914; 0.769; 0.590; 0.380; 0.086; 0.231; 0.409;0.620;
    %target_c=0.6836;
    V_heater=0;
    psi=0;
    phi=0;
    theta=0;
    max_iter=10000;
    it=0;
    delta=50;
    dpr_target=1;
    while delta>0.001 && it<10000
    [psi,delta]=MZI_A([1;0],target_a,psi,imperfections,derivative);
    V_heater=psi;
    it=it+1;
    end
    out_a=simulate_MZI(0,psi,[1;0]);
    PR_B=0.5+out_a(1)*out_a(2)*sin(desired_phi);
    target_b=[target_b,PR_B];
    iter=0;
    delta=50;
    while abs(delta) > 1e-4 && iter < max_iter
        iter = iter + 1;
        [phi, delta] = MZI_B(out_a,PR_B, phi, imperfections, dpr_target);
    end
    [~, powerb2, outb] = mzi_model_bottomArm(phi, out_a, imperfections);
    [~,PR_C]=simulate_MZI(desired_phi,desired_theta,out_a);
    target_c=[target_c,PR_C];
    iter=0;
    delta=50;
    while abs(delta) > 1e-4 && iter < max_iter
        iter = iter + 1;
        [theta, delta] = MZI_C(outb,PR_C, theta, imperfections, dpr_target);
    end
   [powerc1, ~, VC] = mzi_model_topArm(theta, outb, imperfections);
   Power_measured=[Power_measured;powerc1];
   phase_measured=[phase_measured;angdiff(VC(1),VC(2))];
   VC_measured=[VC_measured;VC'];
   VC_true=[VC_true;simulate_MZI(phi,theta,out_a)'];
   i=i+1;
end
end


figure; hold on; grid on;

h1 = plot(NaN, NaN, 'yo');
h2 = plot(NaN, NaN, 'b*');
h3 = plot(NaN, NaN, 'mo');
h4 = plot(NaN, NaN, 'r*');

for ii = 1:10
    plot(real(VC_true(ii,1)), imag(VC_true(ii,1)), 'yo');
    plot(real(VC_measured(ii,1)), imag(VC_measured(ii,1)), 'b*');
    plot(real(VC_true(ii,2)), imag(VC_true(ii,2)), 'mo');
    plot(real(VC_measured(ii,2)), imag(VC_measured(ii,2)), 'r*');
end


xlabel('Re[V_c]');
ylabel('Im[V_c]');
legend([h1 h2 h3 h4], {'Target Vc[0]', 'Measured Vc[0]', 'Target Vc[1]', 'Measured Vc[1]'}, 'Location', 'best');

axis equal;
xlim([-1 1]);
ylim([-1 1]);
text(-0.95, -1.05, '(c)', 'FontSize', 12);


axis equal;
xlim([-1, 1]);
ylim([-1, 1]);


text(-0.95, -1.05, '(c)', 'FontSize', 12);