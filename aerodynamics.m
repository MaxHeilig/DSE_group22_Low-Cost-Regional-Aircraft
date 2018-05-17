function [Re] = aerodynamics (M, A, S, h, V_cr)
[taper, sweep, c_r, c_t, c_mac, b] = planform(M, A, S);
[t, p, rho, v, k, c, mu] = ISA (h);

Re = V_cr * c_mac / v;

