%
% Author Patric Jensfelt
%
function create_ui(filterUI)

clf
p = get(gcf, 'Position');
p(3) = 800;
p(4) = 600;
set(gcf, 'Position', p);

if nargin < 1
    filterUI = 0;
end

global rspeed
global tspeed
global run
global reset
global setUniform
global addDisturbance
global newN
global dispGaussApprox
global resample
global coloredPts
global zRhoStd
global zPhiStd
global lMask
global forceUpdate

% Create a figure and axes
ax = axes('Units','pixels');

% Create push button
btn = uicontrol('Style', 'pushbutton', 'String', 'Quit',...
    'Position', [5 5 50 20],...
    'Callback', @clb_quit);

% Create push button
btn = uicontrol('Style', 'pushbutton', 'String', 'Reset',...
    'Position', [60 5 50 20],...
    'Callback', @clb_reset);

if filterUI
    % Create push button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Uniform',...
        'Position', [5 45 50 20],...
        'Callback', @clb_uniform);
    
    % Create push button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Disturb',...
        'Position', [5 80 50 20],...
        'Callback', @clb_disturbance);
    
    % Create push button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Update',...
        'Position', [5 115 50 20],...
        'Callback', @clb_forceupdate);
    
    tbtn = uicontrol('Style', 'togglebutton', 'String', 'DispGauss',...
        'Position', [115 5 70 20],...
        'Callback', @clb_dispgauss);
    tbtn.Value = dispGaussApprox;
    
    if filterUI == 1
        % Create push button
        tbtn = uicontrol('Style', 'togglebutton', 'String', 'Color',...
            'Position', [5 150 50 20],...
            'Callback', @clb_coloredpts);
        tbtn.Value = coloredPts;
    
        tbtn = uicontrol('Style', 'togglebutton', 'String', 'Resample',...
            'Position', [190 5 70 20],...
            'Callback', @clb_resample);
        tbtn.Value = resample;
        
        % Create pop-up for number of particles
        popup = uicontrol('Style', 'popup', 'String', {'100','1000','10000','100000','1000000'},...
            'Position', [260 5 100 20],...
            'Callback', @clb_numparticles);
        
        if ~isempty(newN)
            menuitems = get(popup,'String');
            for k=1:length(menuitems)
                val = sscanf(menuitems{k},'%d');
                if val == newN
                    set(popup,'Value',k)
                end
            end
        end
    end
    
    % Create slider
    sld = uicontrol('Style', 'slider',...
        'Min',-1,'Max',15,'Value',-1,'SliderStep',[0.1 1],...
        'Position', [360 0 80 20],...
        'Callback', @clb_zrhostd);
    
    % Add a text uicontrol to label the slider.
    zrhostd_txt = uicontrol('Style','text',...
        'Position',[360 20 80 20],...
        'String','No range');
    
    % Create slider
    sld = uicontrol('Style', 'slider',...
        'Min',-1,'Max',15,'Value',-1,'SliderStep',[0.1 1],...
        'Position', [445 0 80 20],...
        'Callback', @clb_zphistd);
    
    % Add a text uicontrol to label the slider.
    zphistd_txt = uicontrol('Style','text',...
        'Position',[445 20 80 20],...
        'String','No bearning');
    
end




% Create push button
btn = uicontrol('Style', 'pushbutton', 'String', 'Stop',...
    'Position', [540 5 50 20],...
    'Callback', @clb_stop);

% Create slider
tsld = uicontrol('Style', 'slider',...
    'Min',0,'Max',1,'Value',0,...
    'Position', [595 0 80 20],...
    'Callback', @clb_tspeed);

% Add a text uicontrol to label the slider.
vtxt = uicontrol('Style','text',...
    'Position',[595 20 80 20],...
    'String','v=0m/s');

% Create slider
rsld = uicontrol('Style', 'slider',...
    'Min',-1,'Max',1,'Value',0,...
    'Position', [680 0 120 20],...
    'Callback', @clb_rspeed);

% Add a text uicontrol to label the slider.
wtxt = uicontrol('Style','text',...
    'Position',[680 20 120 20],...
    'String','w=0deg/s');

btn = uicontrol('Style', 'pushbutton', 'String', 'w=0',...
    'Position', [755 40 40 20],...
    'Callback', @clb_w0);

tbtn = uicontrol('Style', 'togglebutton', 'String', 'L1',...
    'Position', [755 75 40 20],...
    'Callback', @clb_L1);
tbtn.Value = lMask(1);

tbtn = uicontrol('Style', 'togglebutton', 'String', 'L2',...
    'Position', [755 110 40 20],...
    'Callback', @clb_L2);
tbtn.Value = lMask(2);

tbtn = uicontrol('Style', 'togglebutton', 'String', 'L3',...
    'Position', [755 145 40 20],...
    'Callback', @clb_L3);
tbtn.Value = lMask(3);

tbtn = uicontrol('Style', 'togglebutton', 'String', 'L4',...
    'Position', [755 180 40 20],...
    'Callback', @clb_L4);
tbtn.Value = lMask(4);


    function clb_tspeed(source,callbackdata)
        tspeed = source.Value;
        vtxt.String = sprintf('v=%.3fm/s',tspeed);
    end

    function clb_rspeed(source,callbackdata)
        rspeed = -2.0*source.Value;
        wtxt.String = sprintf('w=%.1fdeg/s',rspeed*180/pi);
    end

    function clb_zrhostd(source,callbackdata)
        val = source.Value;
        if val <= 0
            zRhoStd = -1;
        elseif val <= 5
            zRhoStd = 0.01 * val;
        else
            zRhoStd = 0.1 * (val-5);
        end
        if val < 0
            zrhostd_txt.String = 'No range';
        else
            zrhostd_txt.String = sprintf('zRhoStd=%.3fm',zRhoStd);
        end
    end

    function clb_zphistd(source,callbackdata)
        val = source.Value;
        if val <= 0
            zPhiStd = -1;
        elseif val <= 5
            zPhiStd = 0.1*pi/180 * val;
        else
            zPhiStd = 1*pi/180 * (val-5);
        end
        if val < 0
            zphistd_txt.String = 'No bearning';
        else
            zphistd_txt.String = sprintf('zPhiStd=%.3fdeg',zPhiStd*180/pi);
        end
    end

    function clb_stop(source,callbackdata)
        tspeed = 0;
        rspeed = 0;
        tsld.set('Value',0);
        rsld.set('Value',0);
        vtxt.String = 'v=0m/s';
        wtxt.String = 'w=0deg/s';
        disp('Stop pressed')
    end

    function clb_w0(source,callbackdata)
        rspeed = 0;
        rsld.set('Value',0);
        wtxt.String = 'w=0deg/s';
    end

    function clb_reset(source,callbackdata)
        reset = 1;
        disp('Reset pressed')
    end

    function clb_uniform(source,callbackdata)
        setUniform = 1;
        disp('setUniform pressed')
    end

    function clb_disturbance(source,callbackdata)
        addDisturbance = 1;
        disp('addDisturbance pressed')
    end

    function clb_coloredpts(source,callbackdata)
       coloredPts = source.Value;
       disp(sprintf('Color pressed, state=%d', coloredPts))
    end

    function clb_quit(source,callbackdata)
        run = 0;
        disp('Reset pressed')
    end

    function clb_dispgauss(source,callbackdata)
        dispGaussApprox = source.Value;
        disp('Pressed Disp Gauss')
    end

    function clb_L1(source,callbackdata)
        lMask(1) = source.Value;
        disp(sprintf('Pressed L1, used = %d', source.Value))
    end

    function clb_L2(source,callbackdata)
        lMask(2) = source.Value;
        disp(sprintf('Pressed L2, used = %d', source.Value))
    end

    function clb_L3(source,callbackdata)
        lMask(3) = source.Value;
        disp(sprintf('Pressed L3, used = %d', source.Value))
    end

    function clb_L4(source,callbackdata)
        lMask(4) = source.Value;
        disp(sprintf('Pressed L4, used = %d', source.Value))
    end

    function clb_forceupdate(source,callbackdata)
        forceUpdate = 1;
        disp(sprintf('Forcing an update'))
    end

    function clb_resample(source,callbackdata)
        resample = source.Value;
        disp(sprintf('Pressed Resample, resample=%d', resample))
    end

    function clb_numparticles(source,callbackdata)
        newN = sscanf(source.String{source.Value},'%d');
    end
end