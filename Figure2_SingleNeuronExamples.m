%%  Reproduce tuning curves from example neurons in Figure 2
%  This code can be used to explore the family of possible tuning curves at
%  different viewing distances

addpath('helperFunctions')

viewing_distance = 3.25;
motion_speed = 20; % cm/s

env_theta = (0:(pi/1000):2*pi)';    
env_speed = motion_speed*ones(size(env_theta)); % cm/s
x = [env_theta,env_speed];

% TUNING PARAMETERS FOR 3 examples neurons seen in Figure 2
% left eye monocular tuning parameters
pl = [2, 10, 15  ; ... % speed preference
     1, 1, 1e-3   ; ... % baseline firing rate
     1.2, 1.6, 1.4 ;... % sigma (tuning width)
     .07, 8.1, 70.4  ;... % amplitude (pos. side)
     8, 1e-3, 30 ];     % amplitude (neg. side)

% right eye monocular tuning parameters
pr = [2, 5.7, 20  ; ... 
     .05, .06, 1e-3  ; ...
     1.5 , 2, 1.7;...
     .07, 38, 85 ;...
     11, 1e-3, 14 ];
  
p{1} = pl;
p{2} = pr;
p{3} = ones(3,2); % set coefficients of combination to 1
p{4}= viewing_distance; % motion location; viewing distance
p{5}= 0; % motion location; x dimension / lateral displacement
p{6} = 6.5; % interpupillary distance

% calculate the binocular tuning curves
[neurons_orig] = f_binocularTuning_linear(x,p);

% calculate the monocular responses as a function of xz motion direction
vx  = cos(env_theta).*env_speed;
vz = sin(env_theta).*env_speed;
m_x = p{5}; m_z = p{4}; ipd = p{6};
speed_l =  (vx*m_z - vz.*(m_x+ipd/2))./((m_x+ipd/2)^2+m_z^2);   
speed_r =  (vx*m_z - vz.*(m_x-ipd/2))./((m_x-ipd/2)^2+m_z^2); 


mleft = doubleLogNormal_multi(speed_l,p{1});
mright = doubleLogNormal_multi(speed_r,p{2});
neurons = neurons_orig;

% calculate the monocular tuning curves
speeds = -10:.01:10;
left = doubleLogNormal_multi(speeds',p{1});
right = doubleLogNormal_multi(speeds',p{2});


% Plot the tuning curves
figure(3); clf;
cnt=1;
for i=1:3 
    n = (i);
    subplot(3,3,3*cnt-2); hold on; % monocular tuning
    plot(speeds,(left(n,:)),'b','LineWidth',2);
    plot(speeds,(right(n,:)),'r','LineWidth',2);
    box off;
    set(gca,'XTick',[-20:10:20],'YTick',[],'LineWidth',2);
    xlim([-10,10]);
    ylim([-1,max(neurons(n,:))*1.1]);
    if i==1, title('Monocular tuning curves'); legend('left','right'); end
    if i~=3, set(gca,'XTickLabel',{}); end
    if i==3, xlabel('speed (deg/s)'); end
    ylabel('neural response');
    
    subplot(3,3,3*cnt-1); hold on; % monocular tuning in xz direction space
    plot(env_theta/pi*180,mright(n,:)','LineWidth',2,'Color','r');
    plot(env_theta/pi*180,mleft(n,:)','LineWidth',2,'Color','b');
    xlim([-2,362]);
    ylim([-1,max(neurons(n,:))*1.1]);
    box off;
    set(gca,'XTick',0:90:360,'YTick',[],'LineWidth',2);
    if i==1, title('Monocular responses vs. \newlinexz direction'); end
    if i~=3, set(gca,'XTickLabel',{}); end
    if i==3, xlabel('xz motion direction (deg)'); end
    
    subplot(3,3,3*cnt); hold on; % binocular tuning
    plot(env_theta/pi*180,neurons(n,:)','LineWidth',2,'Color','k')
    ylim([-1,max(neurons(n,:))*1.1]);
    xlim([-2,362]);
    box off;
    set(gca,'XTick',0:90:360,'YTick',[],'LineWidth',2);
    if i==1, title('Binocular tuning curves'); end
    if i~=3, set(gca,'XTickLabel',{}); end
    if i==3, xlabel('xz motion direction (deg)'); end
    
    cnt = cnt+1;
end


% set(gcf, 'PaperPosition', [0,0,6,4]); %Position the plot further to the left and down. Extend the plot to fill entire paper.[left bottom width height]
% set(gcf, 'PaperSize', [6,4]); 
% saveas(gcf,'Figure2_SingleNeuronExamples.pdf','pdf');
