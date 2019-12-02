%% For reproducing Supplementary Figure 4
% Plotting individual subject data.

clear; close all;
inits = {'Subject1','Subject2','Subject3'};
figure(1); clf;
purple = [0.5961 0.3059 0.6392];



cnt=1; % counter for figure subplot
for ini=1:length(inits)
    
    load(['data/' inits{ini}]);
    
    
    D = unique(trials.Distance);
    for d = 1:length(D)
        
        subplot(length(inits),length(D),cnt); hold on;
        
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
        
        if d==2 && ini==3
            xlabel('presented motion direction (deg)');
        end
        
        if d==1 && ini==2
            ylabel('reported motion direction (deg)');
        end
        
        if ini==1 && d>1
           title(['view dist: ' num2str(D(d))]) 
        end
        
        if ini==1 && d==1
           title(['S1, view dist: ' num2str(D(d))]) 
        end
        
        if ini > 1 && d==1
            title(['S' num2str(ini)])
        end
        
        cnt = cnt+1;
    end
    
end
set(gcf, 'PaperPosition', [0,0,7,7]);
set(gcf, 'PaperSize', [7,7]);
saveas(gcf,'SupplementaryFigure4_PsychophysicalResultsBySubject' ,'pdf')




