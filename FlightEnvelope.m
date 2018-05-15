clc % clear command line
clear % clear workspace to reduce RAM pressure
close % close figures
% info for building flight envelope are obtained from 'V-n diagram" from
% SEAD

%% conversions
kg_to_lbs = 2.20462;

%% inputs
W_TO = 2200 * kg_to_lbs; % [lbs]
CL_Max = 1.218; % [-]



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