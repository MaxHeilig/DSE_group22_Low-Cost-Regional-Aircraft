function [Re, sweep_h] = aerodynamics (M, A, S, h, C_L_cr, V_h_V)

%% Determine inputs, planform
[taper, sweep_0_25, sweep_0_5, c_r, c_t, c_mac, b] = planform(M, S, A);
[t, p, rho, v, k, a, mu] = ISA (h);

V_cr = M * a;

%% Tail sizing:
V_h = V_h_V * V_cr;
M_h = V_cr/a;
if M_h < 0.7
    sweep_h = 0;
else 
    sweep_h = acos(0.75*(0.935/(M_h+0.03)));
end

%% Airfoil selection
disp(v);
disp(a);
Re = V_cr * c_mac / v;
cl_des = C_L_cr / (cos(sweep_0_25)^2);


end
