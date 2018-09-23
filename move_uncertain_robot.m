%
% Author Patric Jensfelt
%
close all
figure(1)

global tspeed
global rspeed
global run
global reset
global tdStd
global rdaStd
global rdStd

tspeed = 0;
rspeed = 0;
run = 1;
reset = 0;

create_ui

simulation_parameters;

x = 0;
y = 0;
a = 0;
xt = 0;
yt = 0;
at = 0;
h = [];

SIZE = 2;
axis(SIZE*[-1 1 -1 1])

% Factor for calculting the standard deviation in the distance traveled
% noise proportinal to the distance traveled since last iteration
% Make it HUGE to make it show up easily
tdStd = 0.5;

% Factor for calculting the standard deviation in the part of the noise 
% on the rotation, proportinal to the delta angle since last iteration
% Make it HUGE to make it show up easily
rdaStd = 0.5;

% Factor for calculting the standard deviation in the part of the noise 
% on the rotation, proportinal to the distance traveled since last iteration
% Make it HUGE to make it show up easily
rdStd = 0.5;

while (run)
    
    dnoise = (tspeed*dT*tdStd)*randn;
    arnoise = (rspeed*dT*rdaStd)*randn;
    atnoise = (tspeed*dT*rdStd)*randn;
    
    xt = xt + tspeed*dT*cos(at);
    yt = yt + tspeed*dT*sin(at);
    at = at + rspeed*dT;

    x = x + (tspeed*dT+dnoise)*cos(a);
    y = y + (tspeed*dT+dnoise)*sin(a);
    a = a + (rspeed*dT+arnoise) + atnoise;

    if reset
        x = 0;
        y = 0;
        a = 0;
        xt = 0;
        yt = 0;
        at = 0;
        reset = 0;
    end
    
    if ~isempty(h)
        delete(h);
    end    
    hold on
    h = display_robot(xt,yt,at,'k');    
    h = [h display_robot(x,y,a,'b')];
    
    hold off
    drawnow;
    
end



