%
% Author Patric Jensfelt
%
clear
close all
figure(1)

global tspeed
global rspeed
global run
global reset
global tdStd
global rdaStd
global rdStd

tdStd = 1
rdaStd = 1
rdStd = 1

tspeed = 0;
rspeed = 0;
run = 1;
reset = 0;

create_ui

simulation_parameters;

N = 1000;
X = zeros(3,N);
xt = 0;
yt = 0;
at = 0;
h = [];

axis([-1 9 -1 9])

while (run)

    for n=1:N
        dnoise = (tspeed*dT*tdStd)*randn;
        arnoise = (rspeed*dT*rdaStd)*randn;
        atnoise = (tspeed*dT*tdStd)*randn;
    
        X(1,n) = X(1,n) + (tspeed*dT+dnoise)*cos(X(3,n));
        X(2,n) = X(2,n) + (tspeed*dT+dnoise)*sin(X(3,n));
        X(3,n) = X(3,n) + (rspeed*dT+arnoise) + atnoise;
    end
    
    xt = xt + tspeed*dT*cos(at);
    yt = yt + tspeed*dT*sin(at);
    at = at + rspeed*dT;
    
    if reset
        xt = 0;
        yt = 0;
        at = 0;
        X = zeros(3,N);
        reset = 0;
    end
    
    if ~isempty(h)
        delete(h);
    end    
    hold on
    h = [plot(X(1,:),X(2,:),'b.') display_robot(xt,yt,at,'k')];
    hold off
    drawnow;
        
end



