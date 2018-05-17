function [P_avg, P_cruise, V_stall, V_LO, V_cruise, M_cruise, C_L_cruise, ROC] = power_2(s_tot, h_TO, h_cruise, MTOW, S, C_L_max, C_L_TO, A, C_D_0_TO, C_D_0_cr)

% --- constants ---

g_0 = 9.80665;      % gravitational acceleration at sea level [m/s^2]

T_0 = 288.15;       % air temperature at sea level [K]
rho_0 = 1.225;      % air density at sea level [kg/m^3]

gamma = 1.4;        % ratio of specific heats [-]
R = 287.05;         % specific gas constant [J/(kg K)]

lambda = -0.0065;   % lapse rate {K/m];

% --- begin of input parameters ---

%s_tot = 1500;       % runway length [m]
%h_TO = 0;           % runway elevation [m]
h_OB = 15.24;       % screen height [m]
%h_cruise = 7620;    % cruise altitude [m]

rho_TO = rho_0 .* (1 + lambda * h_TO / T_0)^(-g_0 / (lambda * R) - 1);
rho_cruise = rho_0 .* (1 + lambda * h_cruise / T_0)^(-g_0 / (lambda * R) - 1);

% input data for ATR 42-600, concept 8 and concept 9

%MTOW = 29500;       % maximum take-off weight [kg]
%S = 64.3;           % wing area [m^2]
eta_pr = 0.85;       % propeller efficiency [-]
%C_L_max = 2.1;        % maximum lift-coefficient [-]
%C_L_TO = 2.1;         % lift-coefficient for take-off [-]
e = 0.80;            % Oswald efficiency factor [-]
%A = 11;                % aspect ratio [-]
%C_D_0_TO = 0.028;   % zero-lift drag coefficent for take-off [-]
%C_D_0_cr = 0.028;   % zero-lift drag coefficient for cruise [-]
mu_r = 0.02;                % coefficient of dynamic fricion [-]

W = g_0 * MTOW;

% --- end of input parameters ---

V_stall = sqrt(W ./ S * 2 / rho_TO * 1 ./ C_L_max);

% airborn distance
R_a = 0.3048 * 6.96 * V_stall.^2 / g_0;

theta_OB = acos(1 - h_OB ./ R_a);

s_a = R_a .* sin(theta_OB);

% ground roll distance
V_LO = 1.1 * V_stall;
V_avg = V_LO / sqrt(2);

C_D_TO = C_D_0_TO + C_L_TO.^2 ./ (pi * A .* e);
D_avg = C_D_TO * 0.5 * rho_TO .* V_avg.^2 .* S;

L_avg = C_L_TO * 0.5 * rho_TO .* V_avg.^2 .* S;
D_g_avg = mu_r * (W - L_avg);

a_avg = V_LO.^2 / (2 * (s_tot - s_a));

T_avg = W / g_0 .* a_avg + D_avg + D_g_avg;

P_avg = T_avg .* V_avg ./ eta_pr;
P_avg_shp = P_avg / 745.6999;

%display(P_avg_shp);         % take-off power in shp

% cruise speed
C_L_cruise = sqrt((1/3) .* C_D_0_cr * pi .* A .* e);
C_D_cruise = C_D_0_cr + C_L_cruise.^2 ./ (pi * A .* e);
V_cruise = sqrt((W ./ S) * (2 / rho_cruise) .* (1 ./ C_L_cruise));
M_cruise = V_cruise / sqrt(gamma * R * (T_0 + lambda * h_cruise));
P_cruise = C_D_cruise * 0.5 * rho_cruise .* V_cruise.^3 .* S;
%display(V_cruise);          % cruise speed in m/s
%display(M_cruise);          % cruise speed in Mach

%P_cruise_shp = P_cruise / 749.6999;

%display(P_cruise_shp);      % cruise power in shp

% maximum rate of climb
C_L_climb = sqrt(3 * pi * A .* e .* C_D_0_cr);
C_D_climb = C_D_0_cr + C_L_climb.^2 ./ (pi .* A .* e);

V_climb = sqrt(W ./ S * 2 / rho_TO * 1 ./ C_L_climb);
%display(V_climb);           % climb velocity in m/s

P_a = P_avg;
P_r = C_D_climb * 0.5 * rho_TO .* V_climb.^2 .* S;

ROC = (P_a - P_r) ./ W;
%display(ROC);               % ROC in m/s

end