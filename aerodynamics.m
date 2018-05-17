function [Re] = aerodynamics (M, A, S, h)

%% Determine inputs, planform
[taper, sweep, c_r, c_t, c_mac, b] = planform(M, S, A);
[t, p, rho, v, k, c, mu] = ISA (h);

V_cr = M * c;

%% Airfoil selection
Re = V_cr * c_mac / v;

end
