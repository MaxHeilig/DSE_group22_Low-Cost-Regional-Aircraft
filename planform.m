function [taper, sweep, c_r, c_t, b] = planform (M, S, A)
% ADSEE I, L06, S13 (based on Torenbeek)
if M < 0.7
    sweep = 0;
else 
    sweep = acos(0.75*(0.935/(M+0.03)));
end

% ADSEE 1, L06, S18 (based on torenbeek)
taper = 0.2*(2-rad2deg(sweep)*pi/180);

% A = b^2 /S:
b = sqrt(S*A);

% ADSEE 1, L6, S19
c_r = 2*S /((1+taper)*b);
c_t = taper * c_r;

% Plot the planform
y1 = -tan(sweep)*b/2 - 0.25*c_r + 0.25*c_t;
y2 = y1 - c_t;
x = [0, b/2, b/2, 0];
y = [0, y1, y2, -c_r]; 
plot(x, y);