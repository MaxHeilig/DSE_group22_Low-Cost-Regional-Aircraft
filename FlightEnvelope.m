clc % clear command line
clear % clear workspace to reduce RAM pressure
close % close figures
% info for building flight envelope are obtained from 'V-n diagram" from
% SEAD

step = 0.1 % time step
%% Conversions
kg_to_lbs = 2.20462;
lbs_to_N = 4.4482216282509;

%% Inputs
W_TO = 22000 * kg_to_lbs; % [lbs] 
CL_Max = 1.218; % [-]
CL_Min = -CL_Max; % [-]
rho_SL = 1.225; % [kg/m3]
S = 60; % [m2]
V = 0:0.5:200; % [m/s]

% constants
g = 9.81; % [m/s^2]
%% Functions

%% Maximum limit load factors (CS-25)

% Maximum positive limit load factor, n_max
if W_TO > 50000
    n_max = 2.5;
elseif W_TO > 4100
    n_max = 2.1 + (24000/(W_TO + 10000));
else
    n_max = 3.8;
end

% Maximum negative limit load factor, n_max_negative
n_max_negative = -1 * n_max; % according to CS-25

% Calculation of relevant speeds
V_S = sqrt(W_TO*lbs_to_N/(0.5*rho_SL*S*CL_Max)); % 1g stall speed
V_A = V_S*sqrt(n_max); % positive design manoeuvring speed

V_SnegG = sqrt(-W_TO*lbs_to_N/(0.5*rho_SL*S*CL_Min)); % -1g stall speed
V_H = V_SnegG*sqrt(-n_max_negative); % negative design manoeuvring speed

%Make lines
V_0Avec = 0:step:V_A; % speed vector for positive loading
curve_0A = 0.5*rho_SL*V_0Avec.^2*CL_Max/(W_TO*lbs_to_N/S); 

V_0Hvec = 0:step:V_SnegG;
curve_0H = 0.5*rho_SL*V_0Hvec.^2*CL_Min/(W_TO*lbs_to_N/S);
%% Create flight envelope


figure('Name', 'Flight Envelope (V-n Diagram)')
plot(V_0Avec, curve_0A)
hold on
plot(V_0Hvec, curve_0H)
title('Flight Envelope (V-n Diagram)')
xlabel('Indicated Airspeed [m/s]')
ylabel('Load Factor [-]')