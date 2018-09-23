%
% Author Patric Jensfelt
%
function [fx,fy,fa] = motionmodel(x,y,a,D,DA)
fx = x + D*cos(a);
fy = y + D*sin(a);
fa = a + DA;
