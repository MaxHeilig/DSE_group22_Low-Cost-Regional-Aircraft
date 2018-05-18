function [cl, cd] = dragpolar (cl_min, cl_max, CD0, A, e)
pi = 3.1415;
delta_cl = cl_max - cl_min;
cl = linspace (cl_min, cl_max, 100);
cd = CD0 + (cl.^2 ./(pi*A*e));
plot(cl, cd)
end