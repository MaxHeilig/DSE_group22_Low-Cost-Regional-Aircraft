% ADSEE I, L06, S13 (based on Torenbeek)
if M < 0.7
    sweep = 0;
else 
    sweep = 0.75*(0.935/(M+0.03));
end

% ADSEE 1, L06, S18 (based on torenbeek)
taper = 0.2*(2-rad2deg(sweep)*pi/180);

% A = b^2 /S:
b = sqrt(S*A);

% ADSEE 1, L6, S19
c_r = 2*S /((1+lambda)*b);
c_t = lambda * c_r;
   
