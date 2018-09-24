%
% Author Patric Jensfelt
%

% Keep running
global run
run = 1

% Reset flag
global reset
reset = 0;

% Set the distribution to a uniform one
global setUniform
setUniform = 0;

global addDisturbance
addDisturbance = 0;

% Sampling rate
global dT
dT = 0.1;

% Wheel radius [m]
global r
r = 0.05;

% Wheel base [m] (distance betwee wheels along the wheel axis)
global B
B = 0.2;

% Length and whidth of the robot
global Length
Length = 0.3;
global Width
Width = 0.2;

% Translation speed
global tspeed
tspeed = 0;

% Rotation speed
global rspeed
rspeed = 0;

% Factor for calculting the standard deviation in the distance traveled
% noise proportinal to the distance traveled since last iteration
global tdStd
tdStd = 0.1;

% Factor for calculting the standard deviation in the part of the noise 
% on the rotation, proportinal to the delta angle since last iteration
global rdaStd
rdaStd = 0.1;

% Factor for calculting the standard deviation in the part of the noise 
% on the rotation, proportinal to the distance traveled since last iteration
global rdStd
rdStd = 0.1;

% Range measurement std (independent of range)
global rhoStd
rhoStd = 0.1;

% Bearing measurement std
global phiStd
phiStd = 1.0*pi/180;

% Number of particles
global N
N = 10000;

% Number of landmarks
global NL
NL = 4;

% X-coordinate for landmarks
global xL
xL = [-0.5 10.5, 10.5, -0.5];

% X-coordinate for landmarks
global yL
yL = [-0.5, -0.5, 10.5, 10.5];

if length(xL)==NL
else
    disp('WARNING: NL != length(xL)')
end    
if length(yL)==NL
else
    disp('WARNING: NL != length(yL)')
end

global dispGaussApprox
dispGaussApprox = 0;

global zRhoStd
zRhoStd = -1;

global zPhiStd
zPhiStd = -10.0*pi/180;

global resample
resample = 0;

global coloredPts
coloredPts = 1;

global lMask
lMask = ones(1,4);

global newN
newN = 100;

global forceUpdate
forceUpdate = 0;
