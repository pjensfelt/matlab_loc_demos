%
% Author Patric Jensfelt
%
function [rho,phi] = measurementmodel(x,y,a,xL,yL)
rho = sqrt((xL-xt).^2+(yL-yt).^2);
phi = atan2(yL-yt,xL-xt) - at;