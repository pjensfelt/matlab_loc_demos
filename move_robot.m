%
% Author Patric Jensfelt
%
close all
figure(1)

global tspeed
global rspeed
global run
global reset

tspeed = 0;
rspeed = 0;
run = 1;
reset = 0;

create_ui

simulation_parameters;

x = 0;
y = 0;
a = 0;
h = [];

SIZE = 2;
axis(SIZE*[-1 1 -1 1])

while (run)
    
    x = x + tspeed*dT*cos(a);
    y = y + tspeed*dT*sin(a);
    a = a + rspeed*dT;

    if reset
        x = 0;
        y = 0;
        a = 0;
        reset = 0;
    end
    
    if ~isempty(h)
        delete(h);
    end    
    hold on
    h = display_robot(x,y,a);    
    hold off
    drawnow;
    
end



