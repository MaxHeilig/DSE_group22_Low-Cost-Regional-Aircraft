clear all

%---------------------------------------
% Init vars
%---------------------------------------
Re = 1;
af_cl_a0 = 2;
af_clmax = 3;
af_aoa_at_clmax =4;
af_clcdmax = 5;
af_aoa_at_clcdmax = 6;
af_cl_at_clcdmax = 7;
af_cm_cr = 8;
af_cla = 9;
af_aoa_at_Cl0 =10;
af_cd0 = 11;

%---------------------------------------
% general parameters
%---------------------------------------
rho0  = 1.225;
g = 9.81;
rho = 0.3639;


%---------------------------------------
% GIVEN:
%---------------------------------------
L_h = 3; %hoizontal tail lift, given by stab & ctrl
L_v = 4; %vertical tail lift, given by stab & ctrl
V_S_min = 60; %[m/s], minimum stall speed, given by FPP
b_max = 20; %[m], maximum stall speed, give by regulations
V = 230; %[m/s], cruise speed, given by FPP
V_TO = 80; %[m/s], take_off speed
M = 0.78; %[-], Mach number, given by requirements/market
MTOW = 35000*g;
W_cr = 34000 * g; %[N] average weight in cruise, from FPP
e = 0.8 %[-] oswald factor
%---------------------------------------
% Other inputs needed
%---------------------------------------
% From reference aircraft, R^2 = 0.758 (first estimate)
WS = (MTOW/g+15773)/10.6
sweep = 0.4; %[rad] sweep angle
A = 12; %aspect ratio

%---------------------------------------
%  PROGRAM
%---------------------------------------

% Wing Lift coefficient in cruise [-], ADSEE 2, L01, S49:
C_L = 1.1 * WS /(0.5*rho*V^2);



% select airfoil, based on ADSEE 2, L01, S51
% NACA 4412, 4415 or NACA 2415
NACA4412 = [1000000, 0.4833, 1.6706, 16.25, 129.4, 5.25, 1.0518, -0.0995,0, -2.25, 0.008];
NACA4415 = [1000000, 0.4126, 1.5425, 16.75, 119.4, 5.50, 1.0576, -0.0927,0, -2.25, 0.00816 ];
NACA2415 = [1000000, 0.2430, 1.5448, 16.50, 103.0, 5.75, 0.9274, -0.0583,0, -2.25, 0.00712];

%chosen_airfoil:
Airfoil = NACA4412

% Wing lift coefficent in cruise [-], , ADSEE 2, L01, S50:
CL = Airfoil(af_clmax) * (cos(sweep)^2) %/ (sqrt(1-M^2));

% L = 1.1 W = 0.5*rho*V^2:
S = (1.1*W_cr) / (CL*0.5*rho*V^2)

CD = NACA2415(af_cd0) + CL^2/(pi*A*e)

