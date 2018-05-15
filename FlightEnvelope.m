clc % clear command line
clear % clear workspace to reduce RAM pressure
close % close figures
% info for building flight envelope are obtained from 'V-n diagram" from
% SEAD

%% Conversions
kg_to_lbs = 2.20462;
lbs_to_N = 4.4482216282509;

%% Inputs
W_TO = 22000 * kg_to_lbs; % [lbs] 
CL_Max = 1.218; % [-]
rho_SL = 1.225; % [kg/m3]
S = 60; % [m2]
V = 0:0.5:200; % [m/s]

% constants
g = 9.81; % [m/s^2]
%% Functions

%% Maximum positive limit load factor, n_max (CS-25)

if W_TO > 50000
    n_max = 2.5;
elseif W_TO > 4100
    n_max = 2.1 + (24000/(W_TO + 10000));
else
    n_max = 3.8;
end

% Maximum negative limit load factor
n_max_negative = -1 * n_max; % according to CS-25

%% Create flight envelope
V_S = sqrt(W_TO*lbs_to_N/(0.5*rho_SL*S*CL_Max)); % 1g stall speed
V_A = V_S*sqrt(n_max); % positive design manoeuvring speed

V0Avec = 0:0.1:V_A;
curve_0A = 0.5*rho_SL*V0Avec.^2*CL_Max/(W_TO*lbs_to_N/S);

figure('Name', 'Flight Envelope (V-n Diagram)')
plot(V0Avec, curve_0A)
title('Flight Envelope (V-n Diagram)')
xlabel('Indicated Airspeed [m/s]')
ylabel('Load Factor [-]')