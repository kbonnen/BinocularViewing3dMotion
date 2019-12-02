%% Reproduces Figure 6d-f in Bonnen et al. 2019
% Demonstrates how motion direction estimation changes with viewing
% distance in the proposed 3D model
% 

clear; close all;

% load model predictions
inits = {['decoding_opt_czuba_xz_velocity_speed_5_ecc_5vd_20_N_236'],...
    ['decoding_opt_czuba_xz_velocity_speed_5_ecc_5vd_31_N_236'],...
    ['decoding_opt_czuba_xz_velocity_speed_5_ecc_5vd_67_N_236']};
t = table();
for ini=1:length(inits)
    load(['model_results/' inits{ini}]);
    for i=1:length(theta)
        tmp = table;
        tmp.Response = mod(squeeze(estimates(1,i,:)),2*pi);
        tmp.Angle = theta(i)*ones(size(tmp,1),1);
        tmp.SpeedEstimate = squeeze(estimates(2,i,:));
        tmp.Speed = speed*ones(size(tmp,1),1);
        tmp.Distance = dist*ones(size(tmp,1),1);
        t = [t;tmp];
    end
    
end



% plot model predictions
figure(); clf;
purple = [0.5961    0.3059    0.6392];


D = unique(t.Distance);
for d = 1:length(D)
    
    subplot(1,length(D),d); hold on;
    
    ind = t.Distance == D(d);
    motion = t.Angle(ind);
    response = mod(t.Response(ind),2*pi);
    
    % grab the first 15 trials in each distance/direction condition.  
    % This just thins the density of dots plotted making it easier to see
    % what's going on in the plots.  It can be commented out.
    jmp = 100; theend = 7300;
    ind = [];
    for ii = 1:15
        ind = [ind, ii:jmp:theend];
    end
    motion = motion(ind); response = response(ind);
    %%% end grab
    
    plot(rad2deg(motion),rad2deg(response),...
        'o','MarkerFaceColor',purple,'MarkerEdgeColor','k','MarkerSize',2);
    
    set(gca,'YDir','normal','XTick',0:90:360,'YTick',0:90:360);
    axis square
    xlim([0,360]);
    ylim([0,360]);
    
    box off;
    
    
    title(['view. dist.=' num2str(D(d)) 'cm, \newlinespeed=5cm/s'])
    if d==2, xlabel('presented motion direction (deg)'); end    
    if d==1, ylabel('predicted motion direction (deg)'); end
    box off
    set(gca,'LineWidth',2)
    
end

set(gcf, 'PaperPosition', [0,0,7,7]);
set(gcf, 'PaperSize', [7,7]);
saveas(gcf,['Figure6_ModelResults'] ,'pdf')





