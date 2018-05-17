function [CL, CD, CD0] = aero(A)
pi = 3.1415;
e = 0.8;

turboprop = 1;
twinprops = 2;
transportjet = 3;

clean = 1;
takeoff = 2;
land = 3;
undercarriage = 4;

%% First estimates of CL, CD:
% Based on ADSEE 1, L03, S11:
%        clean,  takeoff, land 
CLmax = [1.7,    1.9,     2.6
         1.5,    1.7,     2.1
         1.5,    1.9,     2.3];
     
CD0      = [0.0280, 0.0380,    0.0730,  0
            0.0145, 0.0270,    0.0420,  0.0750]; 
     
CL = sqrt(CD0(clean)*pi*A*e);
CD = drag_polar(CL, CD0(clean), clean, A, e);


%% Notes
% From CS25, notes ADSEE 1, L03, S18:
% Assuming stalling at sea level (landing)
%V_stall = sqrt(WS*2/(rho0, CLmax));
%V_app = 1.2 * V_stall;

end 

%% Drag Polar:
function CD = drag_polar(CL, CD0, config, A, e)
%Based on ADSEE 1, L03, S11:
%          [clean,  takeoff,   land,    undercarriage]
deltaCD0 = [0,      0.015,     0.065,   0.020];
delta_e  = [0,      0.05,      0.10,    0];

CD = CD0(config)+deltaCD0(config) + CL^2 / (pi* A*(e+delta_e(config)));
end 
