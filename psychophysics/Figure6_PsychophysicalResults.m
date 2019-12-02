%% For reproducing Figure 6a-c combined subject data

clear; close all;
inits = {'Subject1','Subject2','Subject3'};
figure(1); clf;
purple = [0.5961 0.3059 0.6392];


% load data
allTrials = table;
for ini=1:length(inits)   
    load(['data/' inits{ini}]);
    allTrials = [allTrials; trials];
end


D = unique(trials.Distance);
for d = 1:length(D)
    
    subplot(1,length(D),d); hold on;
    
    % find the data corresponding to this viewing distance
    ind = trials.Distance == D(d);
    motion = trials.Angle(ind);
    response = trials.Response(ind);
    
    p=plot(rad2deg(motion),rad2deg(response),...
        'o','MarkerFaceColor',purple,'MarkerEdgeColor',purple,'MarkerSize',2);
    
    set(gca,'YDir','normal','XTick',0:90:360,'YTick',0:90:360)
    axis square
    xlim([0,360]);
    ylim([0,360]);
    
    if d==2
        xlabel('presented motion direction (deg)');
    end
    
    if d==1
        ylabel('reported motion direction (deg)');
    end
    
        title(['view dist: ' num2str(D(d))])

end

set(gcf, 'PaperPosition', [0,0,7,3]);
set(gcf, 'PaperSize', [7,3]);
saveas(gcf,'Figure6_PsychophysicalResults' ,'pdf')




