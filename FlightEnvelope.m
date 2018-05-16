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
% aircraft dimensions
W_TO = 22000 * kg_to_lbs; % [lbs] 
CL_Max = 1.218; % [-] clean
CL_Min = -CL_Max; % [-] clean
rho0 = 1.225; % [kg/m3] sea-level density
rho = 1; % [kg/m3] density at design altitude
S = 60; % [m2] reference wing area
c = 2; % [m] chord length
b = 30; % [m] wingspan
a = 2*3.142; % [rad^-1] lift curve

% speeds
V_C = 200; % [ms] Design cruise speed
V_M = 240; % [m/s] Maxmimum speed in level flight
V_D = 270; % [m/s] Design dive speed

% gust speeds
U_C = [15.24 -15.24]; % [m/s] cruise
U_D = [7.62 -7.62]; % [m/s] dive

% constants
g = 9.81; % [m/s^2]

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
V_S = sqrt(W_TO*lbs_to_N/(0.5*rho*S*CL_Max)); % 1g stall speed
V_A = V_S*sqrt(n_max); % positive design manoeuvring speed

V_SnegG = sqrt(-W_TO*lbs_to_N/(0.5*rho*S*CL_Min)); % -1g stall speed
V_H = V_SnegG*sqrt(-n_max_negative); % negative design manoeuvring speed

%Make lines
V_0Avec = 0:step:V_A; % speed vector for positive loading
curve_0A = 0.5*rho*V_0Avec.^2*CL_Max/(W_TO*lbs_to_N/S); 

V_0Hvec = 0:step:V_SnegG;
curve_0H = 0.5*rho*V_0Hvec.^2*CL_Min/(W_TO*lbs_to_N/S);

%% Gust loading
mu = (2*W_TO*lbs_to_N/S)/(rho*g*c*a);
K = 0.88*mu/(5.3 + mu);

n_gust_C = 1 + (0.5*rho0*V_C*a*K*U_C)/(W_TO*lbs_to_N/S);
n_gust_D = 1 + (0.5*rho0*V_D*a*K*U_D)/(W_TO*lbs_to_N/S);

%% Create flight envelope

figure('Name', 'Flight Envelope (V-n Diagram)')
plot(V_0Avec, curve_0A) % positive limit load
hold on
plot(V_0Hvec, curve_0H) % negative limit load

% Plot gust lines
% cruise
plot([1 V_C], [1 n_gust_C(1)], '--b') % positive gust
plot([1 V_C], [1 n_gust_C(2)], '--b') % negative gust
%dive
plot([1 V_D], [1 n_gust_D(1)], '--b') % positive gust
plot([1 V_D], [1 n_gust_D(2)], '--b') % negative gust
% 'close' gust envelope
plot([V_C V_D], [n_gust_C(1) n_gust_D(1)], '--b')
plot([V_C V_D], [n_gust_C(2) n_gust_D(2)], '--b')
plot([V_D V_D], [n_gust_D(1) n_gust_D(2)], '--b')


title('Flight Envelope (V-n Diagram)')
xlabel('Indicated Airspeed [m/s]')
ylabel('Load Factor [-]')