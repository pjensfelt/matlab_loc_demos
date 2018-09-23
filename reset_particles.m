%
% Author Patric Jensfelt
%
function [X,xt,yt,at] = reset_particles(N)

disp(sprintf('reset_particles(%d)',N))

X = zeros(4,N); % x,y,theta,weight

% Set weight to 1/N
X(4,:) = ones(1,N)/N;

xt = 0;
yt = 0;
at = 0;

end