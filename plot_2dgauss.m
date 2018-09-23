%
% Plot an ellipse representing the covariance matrix of a Gaussian
% Modified from gaussPlot2D.m from pmtk3.googlecode.com
%
function h=plot_2dgauss(mu, Sigma, color, plotMarker)

if size(Sigma) ~= [2 2], error('Sigma must be a 2 by 2 matrix'); end

if nargin < 2
    error('Must supply mu,sigma. plat_2dgauss(mu,Sigma)')
end
if nargin < 3
    color = 'b';
end    
if nargin < 4
    plotMarker = true;
end

mu = mu(:);
[U, D] = eig(Sigma);
n = 100;
t = linspace(0, 2*pi, n);
xy = [cos(t); sin(t)];
%k = sqrt(chi2inv(0.95, 2)); % 5.99
k = sqrt(6);
w = (k * U * sqrt(D)) * xy;
z = repmat(mu, [1 n]) + w;
h = plot(z(1, :), z(2, :), 'color', color, 'linewidth', 1);
if plotMarker
  hh=plot(mu(1), mu(2),  'x');
  set(hh,'color',color, 'linewidth', 1,  'markersize', 5);
  h = [h hh];
end
end
