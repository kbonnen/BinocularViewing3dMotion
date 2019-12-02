% Decoding Example - estimate speed and direction
addpath('../helperFunctions/');

clear
% load parameters for simulated neurons
load('parameters/monocularFits.mat');
load('parameters/coefficients.mat');

% set motion location and motion speed
dist = 67;      % viewing distance (cm)
ecc = 0;        % eccentricity (degrees)
speed = 5;     % motion speed (cm/s)
ipd = 6.5;      % inter-pupillary distance
N = length(paramsL); % number of neurons;

tic;
save_file = ['decoding_xz_velocity/decoding_xz_velocity_speed_' num2str(round(speed)) '_ecc_' num2str(ecc) 'vd_'  num2str(round(dist)) '_N_' num2str(N) ];
fprintf(['Speed = ' num2str(speed) ', Distance = ', num2str(dist), ', Eccentricity = ' num2str(ecc) '\n']);

% set up parameters for simulation
p{1} = paramsL; % left eye
p{2} = paramsR; % right eye
p{3} = coeff;
p{4} = dist;  % motion location
p{5} = dist*sind(ecc);
p{6} = ipd;


%% Simulate neural responses to 3D motion
%  noise model: poisson
%  tuning curves: f_binocularTuning_extendedLinear
%

theta = (0:5*(pi/180):2*pi)';   % motion direction (radians) (usually 0:pi/180:2*pi, every degree) or 5*pi/180 to simulate like behavior
m = speed * ones(size(theta));  % speed (cm/s)
x = [theta,m];  % motion direction/speed
nTrials =10;    % number of trials (usually 100)

data = nan(N,nTrials,length(theta)); % simulated responses
for i=1:nTrials
    data(:,i,:) = poissrnd(f_binocularTuning_linear(x,p));
end


%% Calculate the population log likelihood across all possible directions
%  for each trial
%
%  The population log likelihood function (popLogLikelihood) only assumes a
%  poisson noise model.  Any tuning curve function (e.g.
%  @f_binocularTuning_extendedLinear) can be input.
%
repeats = 5;  % we repeat the optimization a few times to avoid local minimums.
estimates_all = nan(2,repeats,nTrials,length(theta));
fval = nan(repeats,nTrials,length(theta));


for i=1:length(theta)
    tic;
    for j=1:nTrials
        for n=1:repeats
            x0 = [2*pi*rand,log(80*rand)];
            opts.Display = 'off';
            [estimates_all(:,n,j,i),fval(n,j,i)] = ...
                fminunc(@negPopLogLikelihood,x0,...
                opts,@f_binocularTuning_linear,data(:,j,i),p);
        end
    end
    fprintf('%i: %2f\n',round(rad2deg(theta(i))),toc);
end

%% choose the best estimates
estimates = nan(2,length(theta),nTrials);
[~,ind] = min(fval);
ind = squeeze(ind);
if size(estimates_all,4)>1
    for j=1:nTrials
        for i=1:length(theta)
            estimates(:,i,j) = estimates_all(:,ind(j,i),j,i);
        end
    end
else
    estimates = squeeze(estimates_all);
end
save(save_file,'theta','estimates_all','fval','estimates','speed','ecc','dist');

%% Plot model predictions
% clear
N = 236;
save_file = ['decoding_xz_velocity/decoding_xz_velocity_speed_' num2str(round(speed)) '_ecc_' num2str(ecc) 'vd_'  num2str(round(dist)) '_N_' num2str(N) ];


% plot away
figure(3); clf;
subplot(121);
plot(rad2deg(theta),mod(rad2deg(squeeze(estimates(1,:,:))),360),'k.');
set(gca,'XTick',0:90:360,'YTick',0:90:360,'FontSize',14);
xlabel('presented motion direction (deg.)'); ylabel('model prediction (deg.)');
xlim([-5,365]);
ylim([-5,365]);
axis square
box off;

subplot(122);
h=histogram(squeeze(exp(estimates(2,:,:))),0:speed/10:3*speed); hold on;
plot([speed,speed],[0,1.2*max(h.Values)],'k','LineWidth',3)

xlabel('presented motion speed (cm/s)');
set(gca,'FontSize',14);
axis square
box off;


set(gcf, 'PaperPosition', [0,0,8,4]); %Position the plot further to the left and down. Extend the plot to fill entire paper.[left bottom width height]
set(gcf, 'PaperSize', [8,4]);
saveas(gcf,[save_file '.pdf'],'pdf');


%% Explore the relationship between speed and direction decoding
N = 236;
save_file = ['decoding_xz_velocity/decoding_xz_velocity_speed_' num2str(round(speed)) '_ecc_' num2str(ecc) 'vd_'  num2str(round(dist)) '_N_' num2str(N) ];

% plot away
figure(3); clf;
subplot(221);
plot(rad2deg(theta),mod(rad2deg(squeeze(estimates(1,:,:))),360),'k.');
set(gca,'XTick',0:90:360,'YTick',0:90:360,'FontSize',14);
xlabel('presented motion direction (deg.)'); ylabel('model prediction (deg.)');
xlim([-5,365]);
ylim([-5,365]);
axis square
box off;

subplot(222);
m=1.2*quantile(exp(estimates(2,:)),.95);
mmin = .8*quantile(exp(estimates(2,:)),.01);
s_edges = mmin:.02*m:m;
s_x = s_edges(1:end-1)+diff(s_edges)/2;
h=histcounts(squeeze(exp(estimates(2,:,:))),s_edges,'Normalization','Probability');
plot(s_x,h,'k','LineWidth',2); hold on;
plot([speed,speed],[0,1.2*max(h)],'k--','LineWidth',1)
xlabel('presented motion speed (cm/s)');
set(gca,'FontSize',14,'Xlim',[mmin,m]);
axis square
box off;


subplot(224); hold on;
m=1.1*quantile(exp(estimates(2,:)),.95);
s_edges = 0:.02*m:m;
s_x = s_edges(1:end-1)+diff(s_edges)/2;
rTheta = mod(rad2deg(squeeze(estimates(1,:,:))),360);
rSpeed = squeeze(exp(estimates(2,:,:)));
chunks = 5;
thetas = repmat(rad2deg(theta),1,size(estimates,3));

bounds = [0,3,7,15,30,100];

for i=1:chunks
    
    qs = bounds(i:i+1);
    ind = rSpeed<qs(2) & rSpeed>qs(1);
    l{i} = sprintf('%.1f - %.1f',round(10*qs)/10);
    
    
    subplot(224);
    h=histcounts(rSpeed(ind),s_edges);
    plot(s_x,h,'LineWidth',2); hold on;
    
    subplot(223); hold on;
    plot(thetas(ind),rTheta(ind),'.');
    
end


subplot(223);
set(gca,'XTick',0:90:360,'YTick',0:90:360,'FontSize',14);
xlabel('presented motion direction (deg.)'); ylabel('model prediction (deg.)');
xlim([-5,365]);
ylim([-5,365]);
axis square
box off;

subplot(224);
plot([speed,speed],[0,numel(rSpeed)/12],'k--','LineWidth',1)
l{end+1} = 'true speed';
legend(l);
xlabel('presented motion speed (cm/s)');
set(gca,'FontSize',14,'Xlim',[0,m]);
axis square
box off;

set(gcf, 'PaperPosition', [0,0,8,8]); %Position the plot further to the left and down. Extend the plot to fill entire paper.[left bottom width height]
set(gcf, 'PaperSize', [8,8]);
saveas(gcf,[ save_file '_by_speeds.pdf'],'pdf');

