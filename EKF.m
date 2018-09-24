%
% Author Patric Jensfelt
%
clear
close all
figure(1)

% Load simulation parameters
simulation_parameters;

dispGaussApprox = 1;

% Create the UI
create_ui(2)

% Display handles to
h = [];

axis([-1 11 -1 11])

% Plot the landmarks
plot(xL,yL,'ko','MarkerSize',5)
text(xL(1)-0.3, yL(1)-0.3, '1')
text(xL(2)+0.3, yL(2)-0.3, '2')
text(xL(3)+0.3, yL(3)+0.3, '3')
text(xL(4)-0.3, yL(4)+0.3, '4')

xt=0; yt= 0; at = 0;
X0 = zeros(3,1);
P0 = 1e-6*eye(3);
X = X0;
P = P0;

firstIter = 0;

while (run)
    
    % Update true pose
    xt = xt + tspeed*dT*cos(at);
    yt = yt + tspeed*dT*sin(at);
    at = at + rspeed*dT;
    
    % Generate measurements
    rho = sqrt((xL-xt).^2+(yL-yt).^2) + rhoStd*randn(1,NL);
    phi = atan2(yL-yt,xL-xt) - at + phiStd*randn(1,NL);
    
    if forceUpdate == 1 || abs(tspeed) > 1e-6 || abs(rspeed) > 1e-6
        
        if forceUpdate == 1
            disp('Asked to force an update')
        end
        forceUpdate = 0;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Predict motion
        dnoise = (tspeed*dT*tdStd)*randn;
        arnoise = (rspeed*dT*rdaStd)*randn;
        atnoise = (tspeed*dT*tdStd)*randn;
        
        X(1) = X(1) + (tspeed*dT+dnoise)*cos(X(3));
        X(2) = X(2) + (tspeed*dT+dnoise)*sin(X(3));
        X(3) = X(3) + (rspeed*dT+arnoise) + atnoise;
        
        
        D = tspeed*dT;
        DA = rspeed*dT;
        
        A = [[ 1, 0, -D*sin(at)];
            [ 0, 1, D*cos(at)];
            [ 0, 0, 1]];
        
        W = [cos(X(3)) 0 0;sin(X(3)) 0 0; 0 1 1];
        Q = diag([(D*tdStd)^2 (DA*rdaStd)^2 (D*tdStd)^2]);
        
        P = A*P*A' + W*Q*W';
        
        H=[];
        R = [];
        innov = [];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Measurement update
        
        
        % Loop over the measurements
        for l = 1:NL
            
            % Check if this landmark is used or not
            if lMask(l) == 0
                continue
            end
            
            zRho = sqrt((xL(l)-X(1)).^2+(yL(l)-X(2)).^2);
            
            % Use range measurement
            if zRhoStd > 0
                H = [H; [ -(2*xL(l) - 2*X(1))/(2*zRho), -(2*yL(l) - 2*X(2))/(2*zRho), 0]];
                innov = [innov; rho(l) - zRho];
                R = [R zRhoStd^2];
            end
            
            % Use bearing measurement
            if zPhiStd > 0
                zPhi = atan2(yL(l)-X(2),xL(l)-X(1)) - X(3);
                dPhi = phi(l) - zPhi;
                while dPhi > pi
                    dPhi = dPhi - 2.0*pi;
                end
                while dPhi < -pi
                    dPhi = dPhi + 2.0*pi;
                end
                H = [H; [ (yL(l)-X(2))/zRho^2, -(xL(l)-X(1))/zRho^2, -1]];
                innov = [innov; dPhi];
                R = [R zPhiStd^2];
            end
        end
        
        if ~isempty(innov)
            % Turn our diagonal vector with variances into a matrix
            R = diag(R);
            
            K = P*H'*inv(H*P*H' + R);
            X = X + K*innov;
            P = (eye(3) - K*H)*P;
            
        end
        
    end
    
    if reset
        xt=0; yt= 0; at = 0;
        X = X0;
        P = P0;
        reset = 0;
    end
    
    if setUniform
        X = zeros(3,1);
        P = 1e4*eye(3);
        setUniform = 0;
    end
    
    if addDisturbance
        xt = xt + 0.25*rand(1,1);
        yt = yt + 0.25*rand(1,1);
        at = at + 90/pi*180*rand(1,1);
        addDisturbance = 0;
    end
    
    if ~isempty(h)
        delete(h);
    end
    hold on
    h = [plot(X(1,:),X(2,:),'b.') display_robot(xt,yt,at,'k',1)];
    if zRhoStd > 0 || zPhiStd > 0
        for k=1:NL
            
            % Check if this landmark is used or not
            if lMask(k) == 0
                continue
            end
            
            h = [h plot([xt xt+rho(k)*cos(at+phi(k))],[yt yt+rho(k)*sin(at+phi(k))],'m')];
        end
    end
    
    if dispGaussApprox
        h = [h plot_2dgauss(X(1:2), P(1:2,1:2), 'b', true)];
        dirLen = 0.5;
        h = [h plot([X(1)+[0 dirLen*cos(X(3))]], [X(2)+[0 dirLen*sin(X(3))]],'b')];
        h = [h plot([X(1)+[0 dirLen*cos(X(3)+3*sqrt(P(3,3)))]], [X(2)+[0 dirLen*sin(X(3)+3*sqrt(P(3,3)))]],'b')];
    end
    
    hold off
    drawnow;
    
end





