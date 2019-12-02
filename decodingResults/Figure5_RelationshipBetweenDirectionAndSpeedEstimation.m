%% Reproduces Figure 5 in Bonnen et al. 2019
% Demonstrates the relationship between speed and direction in estimating
% xz velocity (speed, direction) using the proposed 3D model.
% 

clear;
figure(1); clf;
npanels = 3;

speed_bounds = [0:30,1000];
lims = [-1.5,1.5;-.35,.35;-.225,.225;-.12,.12];
    cmap = flipud(jet(length(speed_bounds))); 
    colormap(cmap);


distances = [3,20,31,67];
for dd=1:length(distances)
    N = 236; speed = 5; ecc = 0; view_dist = distances(dd);
    load_file = ['model_results/decoding_opt_czuba_xz_velocity_speed_' num2str(round(speed)) '_ecc_' num2str(ecc) 'vd_'  num2str(round(view_dist)) '_N_' num2str(N) ];
    load(load_file)
    estimates = estimates(:,:,1:10); % limit the number of dots plotted per viewing distance.  The density is easier to see this way, but it's not necessary.  You can comment this out.
    
    m=1.1*quantile(exp(estimates(2,:)),.95);
    s_edges = 0:.02*m:m;
    s_x = s_edges(1:end-1)+diff(s_edges)/2;
    
    % calculate the predicted speed and direction
    predictedTheta = mod(rad2deg(squeeze(estimates(1,:,:))),360);
    predictedSpeed = squeeze(exp(estimates(2,:,:)));
    chunks = 5;
    thetas = repmat(rad2deg(theta),1,size(estimates,3));
    
    directions = 0:5:360;
    
    % calculate the right and left eye velocities for the predicted speed
    % and direction
    [vL,vR] = TwoD_motion_velocities(view_dist,ecc,predictedTheta(:),predictedSpeed(:),6.5);
    vR = reshape(vR,size(predictedTheta));
    vL = reshape(vL,size(predictedTheta));
    
    % calculate the true right and left eye velocities for true speed and
    % direction
    [truevL,truevR] = TwoD_motion_velocities(view_dist,ecc,thetas(:),speed,6.5);
    truevR = reshape(truevR,size(predictedTheta));
    truevL = reshape(truevL,size(predictedTheta));
    
    % Plot the prediction motion direction with colormap to indicate predicted speed   
    subplot(npanels,length(distances),(dd)); hold on;
    for i=1:length(speed_bounds)-1
        qs = speed_bounds(i:i+1);
        ind = predictedSpeed<qs(2) & predictedSpeed>qs(1);
        l{i} = sprintf('%.1f - %.1f',round(10*qs)/10);
        p{i}=plot(thetas(ind),predictedTheta(ind),'.','Color',cmap(i,:));
        
    end
    plot(thetas,thetas,'k','LineWidth',1);
    set(gca,'XTick',0:90:360,'YTick',0:90:360,'FontSize',14);
    xlim([-5,365]);
    ylim([-5,365]);
    axis square
    box off;
    
    if dd==2, xlabel('presented motion direction (deg)'); end
    if dd==1, ylabel('model prediction (deg)'); end
    
    % Plot the predicted left eye velocity vs the predicted right eye velocity
    % colored by the speed estimate.
    titles = {'Left Eye','Right eye'};
    subplot(npanels,length(distances),length(distances)+dd); hold on;
    for i=1:length(speed_bounds)-1
        qs = speed_bounds(i:i+1);
        ind = predictedSpeed<qs(2) & predictedSpeed>qs(1);
        plot(vR(ind),vL(ind),'.','Color',cmap(i,:));
    end
    
    plot(truevR(:),truevL(:),'k','LineWidth',1);
    r = refline(1,0);
    set(r,'Color','k','LineStyle','--');
    r = refline(-1,0);
    set(r,'Color','k','LineStyle','--');
    
    ylim(lims(dd,:)); xlim(lims(dd,:));
    axis square;
    box off;
    if dd==2, xlabel('predicted right eye velocity (deg/s)'); end
    if dd==1, ylabel('predicted left eye velocity (deg/s)'); end
    
    
    % Plot a colormap which demonstrates the relationship between the estimate
    % of environmental speed and the predicted left/right eye velocities 
    subplot(npanels,length(distances),2*length(distances)+dd); hold on;
    [VL,VR] = meshgrid(lims(dd,1):diff(lims(dd,:))/100:lims(dd,2),...
        lims(dd,1):diff(lims(dd,:))/100:lims(dd,2));
    
    clear Wtheta Wm
    for i=1:numel(VL)
        [Wtheta(i),Wm(i)] = retinal2environmentalvelocity(VL(i),VR(i),0,distances(dd),6.5);
    end

    contourf(VL,VR,reshape(Wm,size(VL)),speed_bounds);
    contour(VL,VR,reshape(Wm,size(VL)),speed_bounds);
    
    plot(truevR(:),truevL(:),'k','LineWidth',1);
    
    ylim(lims(dd,:)); xlim(lims(dd,:));
    caxis([0,30]);
    if dd==2, xlabel('predicted right eye velocity (deg/s)'); end
    if dd==1, ylabel('predicted left eye velocity (deg/s)'); end
    
    axis square;
    box off;
    
    
end


set(gcf, 'PaperPosition', [0,0,7,5]); %Position the plot further to the left and down. Extend the plot to fill entire paper.[left bottom width height]
set(gcf, 'PaperSize', [7,5]);
saveas(gcf,'Figure5_RelationshipBetweenDirectionAndSpeedEstimation.pdf');

