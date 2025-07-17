PR_target=0.7;
V_heater=0;
psi=0.392;
delta=50;
while abs(delta)>0.01
[V_heater,delta] = MZI_a(PR_target,V_heater,psi);
psi=V_heater
end