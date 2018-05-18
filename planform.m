function [taper, sweep_0_25, sweep_0_5, c_r, c_t, c_mac, c, b] = planform (M, S, A)
% ADSEE I, L06, S13 (based on Torenbeek)
if M < 0.7
    sweep_0_25 = 0;
else 
    sweep_0_25 = acos(0.75*(0.935/(M+0.03)));
end

% ADSEE 1, L06, S18 (based on torenbeek)
taper = 0.2*(2-rad2deg(sweep_0_25)*pi/180);

% A = b^2 /S:
b = sqrt(S*A);

% ADSEE 1, L6, S19
c_r = 2*S /((1+taper)*b);
c_t = taper * c_r;

% Find points to plot the planform
y1 = -tan(sweep_0_25)*b/2 - 0.25*c_r + 0.25*c_t;
y2 = y1 - c_t;
x = [0, b/2, b/2, 0];
y = [0, y1, y2, -c_r]; 


% find the MAC with Martijn's method
c_mac = c_r*(2/3)*((1+taper + taper^2)/(1+taper));
y_mac = b/6*(c_r+2*c_t)/(c_r + c_t);


% find the MAC with graphical method
% y_mac = b/2*(-c_r-2*c_t)/(y2-y1-3*c_r-2*c_t);
x_le = y1/(b/2)*y_mac;
x_te = (y2+c_r)/(b/2)*y_mac -c_r;
% c_mac = x_le - x_te;

% plot
plot(x, y); hold on;
plot ([y_mac, y_mac], [x_le,  x_te]);

% sweep_0.5
sweep_0_5 = (y1+(c_t-c_r)/2)/(b/2);

% c as function of span

axis equal



 




