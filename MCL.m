%
% Author Patric Jensfelt
%
clear
close all
figure(1)

% Load simulation parameters
simulation_parameters;

% Number of particles
N = 100;
newN = N;

% Create the UI and turn on the particle additions
create_ui(1)

[X,xt,yt,at] = reset_particles(N);

% Display handles to
h = [];

axis([-1 11 -1 11])

% Plot the landmarks
plot(xL,yL,'ko','MarkerSize',5)
text(xL(1)-0.3, yL(1)-0.3, '1')
text(xL(2)+0.3, yL(2)-0.3, '2')
text(xL(3)+0.3, yL(3)+0.3, '3')
text(xL(4)-0.3, yL(4)+0.3, '4')

firstIter = 0;

tdStd = 1.25;
rdaStd = 1.25;
rdStd = 1.25;

tinyWeights = false;

while (run)
    
    %disp(sprintf('Sample set has (min=%e, max=%e)', min(X(4,:)), max(X(4,:))))
    
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
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Resample
        if resample && (sum(X(4,:)) < 0.5)
            disp('Resampling')
            X = X(:,resample_stratified(X(4,:),N));
            X(4,:) = ones(1,N)/N;
        end
        
        % Check the status of the weights. If weights get very small we
        % risk causing numerical issues.
        % This is not a problem in practice because we resample but in this
        % demo you can turn resampling off
        if min(X(4,:)) < 1e-200
            if tinyWeights == false
                disp(sprintf('You should really resample now or consider increasing sensor noise (min=%e, max=%e)', min(X(4,:)), max(X(4,:))))
            end
            tinyWeights = true;
        else
            tinyWeights = false;
        end
        
        % Run through the particles and perform the predictin and update
        % In MATLAB this can be done MUCH more efficient using matrix
        % operations but it makes it much hader to understand the code
        oldN = N; % Store old value of number of particles as 
        for n=1:oldN
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Predict motion
            dnoise = (tspeed*dT*tdStd)*randn;
            arnoise = (rspeed*dT*rdaStd)*randn;
            atnoise = (tspeed*dT*tdStd)*randn;
            
            X(1,n) = X(1,n) + (tspeed*dT+dnoise)*cos(X(3,n));
            X(2,n) = X(2,n) + (tspeed*dT+dnoise)*sin(X(3,n));
            X(3,n) = X(3,n) + (rspeed*dT+arnoise) + atnoise;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Measurement update
            
            % Define the standard deviations for the measurement model in the
            % particle filter. In practice we do not know the actual
            % measurement noise values and even if we did we might not want to
            % use exactly the same values.
            
            % Loop over the measurements
            for l = 1:NL
                
                % Check if this landmark is used or not
                if lMask(l) == 0
                    continue
                end
                
                % Update with range measurement
                if zRhoStd > 0
                    zRho = sqrt((xL(l)-X(1,n)).^2+(yL(l)-X(2,n)).^2);
                    X(4,n) = X(4,n)*exp(-0.5*((rho(l) - zRho)/zRhoStd).^2);
                end
                
                % Update with bearing measurement
                if zPhiStd > 0
                    zPhi = atan2(yL(l)-X(2,n),xL(l)-X(1,n)) - X(3,n);
                    dPhi = phi(l) - zPhi;
                    while dPhi > pi
                        dPhi = dPhi - 2.0*pi;
                    end
                    while dPhi < -pi
                    	dPhi = dPhi + 2.0*pi;
                    end
                    X(4,n) = X(4,n)*exp(-0.5*(dPhi/zPhiStd).^2);
                end            
            end
        end
    end
    
    if reset
        [X,xt,yt,at] = reset_particles(N);
        reset = 0;
    end
    
    if setUniform
        M = axis;
        X(1,:) = M(1) + (M(2)-M(1))*rand(1,size(X,2));
        X(2,:) = M(3) + (M(4)-M(3))*rand(1,size(X,2));
        X(3,:) = 2*pi*rand(1, size(X,2));
        X(4,:) = ones(1, size(X,2)) / size(X,2);
        setUniform = 0;
    end
    
    if addDisturbance
        xt = xt + 0.25*rand(1,1);
        yt = yt + 0.25*rand(1,1);
        at = at + 90/pi*180*rand(1,1);
        addDisturbance = 0;
    end
    
    if N ~= newN
        N = newN;
    	disp(sprintf('Samples partciles since N=%d and size(X,2)=%d', N, size(X,2)))
        X = X(:,resample_stratified(X(4,:),N));
    end
    
    if ~isempty(h)
        delete(h);
    end
    hold on
    if coloredPts
        h = [scatter(X(1,:),X(2,:),10,X(4,:)) display_robot(xt,yt,at,'k',1)];
    else
        h = [plot(X(1,:),X(2,:),'b.') display_robot(xt,yt,at,'k',1)];
    end
    if zRhoStd > 0 || zPhiStd > 0
        for k=1:NL
            if lMask(k) == 0
            	continue
            end
                
            h = [h plot([xt xt+rho(k)*cos(at+phi(k))],[yt yt+rho(k)*sin(at+phi(k))],'m')];
        end
    end
    
    if dispGaussApprox
        indx = resample_stratified(X(4,:),1000);
        if (max(indx)-min(indx)) ~= 0
            % Calculations breads down when all particles are
            % resampled from the same parent
            XX = X(:,indx);
            muXY = mean(XX(1:2,:),2);
            sigXY = cov(XX(1:2,:)');
            cosA = cos(XX(3,:));
            sinA = sin(XX(3,:));
            muA = atan2(mean(sinA),mean(cosA));
            h = [h plot_2dgauss(muXY, sigXY, 'r', true)];
            dirLen = 0.5;
            h = [h plot([muXY(1)+[0 dirLen*cos(muA)]], [muXY(2)+[0 dirLen*sin(muA)]],'r')];
        end
    end
    
    hold off
    drawnow;
    
end





