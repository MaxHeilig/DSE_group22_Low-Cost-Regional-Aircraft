function[Tto, Tcr, Vsto, Vstl, Vcr, RC, Mcr, fc] = Performance(MTOW, CLmaxto, CLmaxl, CD0, S, e, A, sfc)
%% Constants  
T0 = 288.15;
R = 287.05;
rho0 = 1.225;
ssgamma = 1.4;
g0 = 9.80665;
gradient = -0.0065;
p0 = 101325;
h = 10000;                      %10000 m height 
mur = 0.02; 
murbr = 0.4;
hOB = 10.7; 

%% Inputs by others----------------------
OEW = 0; 
%MTOW = 33406;                   %CHANGE
W = MTOW *g0;
%S = 73.3 ;                         %CHANGE
%e = 0.8;                        
%A = 8;                          %CHANGE
%CD0 = 0.017;                    %CHANGE
%CD0 = f/S
%CLmaxto = 2.2;                  %CHANGE
%CLmaxl = 2.8



%% ISA calculations
T1 = T0 + gradient*h; 
p1 = p0 *((T1/T0)^(-g0/(gradient*R)));
rho1 = rho0 * ((T1/T0)^((-g0/(gradient*R))-1.));


%% Take- Off
rhoto = rho0 ;
CD0to = CD0 + 0.015+0.02 ;                                                   %Assumed constant
eto = e+0.05;                                                                %Assumed constant

CDmaxto = CD0to+CLmaxto^2/(pi*A*eto);
Vsto = sqrt((W/S)*(2/rhoto)*(1/CLmaxto));
VLO = 1.05*Vsto; 
Vavg = VLO/(sqrt(2));

Davgto = 0.5*rhoto*Vavg^2*S*CDmaxto; 
Lavgto = 0.5*rhoto*Vavg^2*S*CLmaxto; 
rwl = 1500 ;
%slo = (3/5)*rwl ;

nto = (0.5*rhoto*VLO^2*S*(CLmaxto))/(0.5*rhoto*Vsto^2*S*CLmaxto);
R = (VLO^2)/(g0*(nto-1));
thetaOB = acos(1-(hOB/R));

strans = (VLO^2/(0.15*g0))*sin(thetaOB);
sclimb = (hOB-(1-cos(thetaOB))*(VLO^2/(0.15*g0)))/(tan(thetaOB));
sa = R*sin(thetaOB);
sb = strans+sclimb ;
slo = rwl-sa;

Tto = (1.44*W^2)/((slo*g0*rhoto*S*CLmaxto)) + Davgto + mur*(W-Lavgto);

%% Cruise Speed
%CD0clean = 0.0145
CLopt = sqrt((1/3)*CD0*pi*A*e);
Vcr = sqrt(((0.95*W)/S)*(2/rho1)*(1/CLopt));
CDopt = CD0+CLopt^2/(pi*A*e);
Tcr = CDopt*0.5*rho1*Vcr^2*S; 
Mcr = (Vcr/(sqrt(1.4*278.15*T1)));

%% Rate of Climb 
Vroc = 1.2*Vsto; 
Pa = Tto * Vroc;
D = 0.5*rho0*S*Vroc^2*CDmaxto;
Pr = D * Vroc; 

RC = (Pa-Pr)/W; 
gamma = asin(RC/Vroc);

%% Stall Speed at Landing
LW = 0.85 * W;
Vstl = sqrt((LW/S)*(2/rho0)*(1/CLmaxl));

%% Landing performance
deltan = 0.10; %subsonic jet, F&O slide 57, landing
Rl = 1.3^2*(((LW/S)*(2/rho0)*(1/CLmaxl))/(deltan*g0));
agamma = 3*(pi/180);
xairl = Rl*sin(agamma)+((hOB-(1-cos(agamma))*Rl)/tan(agamma));
xtr = 2.6*Vstl;

Vl = 1.3*Vstl;
Vavgl = Vl/(sqrt(2));

Davgl = 0.5*rhoto*Vavgl^2*S*CDmaxto; 
Lavgl = 0.5*rhoto*Vavgl^2*S*CLmaxto; 

xbrakel = (LW^2/(2*g0*S))*(2/rho0)*(1.3^2/CLmaxl)*(1/(Davgl+murbr*(LW-Lavgl)));

xland = xairl+xtr+xbrakel;

%% fuel consumption
if nargin < 8
    stc = 0.0000198;
else
    stc= sfc;
end
fc = Tcr*stc*3600;

end 