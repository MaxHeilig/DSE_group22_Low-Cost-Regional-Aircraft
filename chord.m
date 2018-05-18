function [c, c_t] = chord (y, sweep_0_25, b, c_r, c_t)
y1 = -tan(sweep_0_25)*b/2 - 0.25*c_r + 0.25*c_t;
y2 = y1 - c_t;

c = (y2 - c_r)/(b/2)*y  - y1/(b/2)*y-c_r;
c_t = cos(sweep)*c*0.25 + 0.75*c/(cos(sweep));
