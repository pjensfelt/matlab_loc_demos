%
% Adapted from ksdensity2d from pmtk3.googlecode.com
%
function [f, gridx1, gridx2] = est_gaussian_2d(X)

[N,p] = size(X);
npoints = 50;
gridx1 = linspace(min(X(1,:)), max(X(1,:)), npoints);
gridx2 = linspace(min(X(2,:)), max(X(2,:)), npoints);

m1 = length(gridx1);
m2 = length(gridx2);

% Choose bandwidths optimally for Gaussian kernel
if nargin < 4 || isempty(bw)
     sig1 = median(abs(gridx1-median(gridx1))) / 0.6745;
     if sig1 <= 0, sig1 = max(gridx1) - min(gridx1); end
     if sig1 > 0
         bw(1) = sig1 * (1/N)^(1/6);
     else
         bw(1) = 1;
     end
     sig2 = median(abs(gridx2-median(gridx2))) / 0.6745;
     if sig2 <= 0, sig2 = max(gridx2) - min(gridx2); end
     if sig2 > 0
         bw(2) = sig2 * (1/N)^(1/6);
     else
         bw(2) = 1;
     end
end

N
bw
sig1
sig2

% Compute the kernel density estimate
[gridx2,gridx1] = meshgrid(gridx2,gridx1);
x1 = repmat(gridx1, [1,1,N]);
x2 = repmat(gridx2, [1,1,N]);
mu1(1,1,:) = X(1,:)'; mu1 = repmat(mu1,[m1,m2,1]);
mu2(1,1,:) = X(2,:)'; mu2 = repmat(mu2,[m1,m2,1]);
f = sum(normpdf(x1,mu1,bw(1)) .* normpdf(x2,mu2,bw(2)), 3) / N;

end