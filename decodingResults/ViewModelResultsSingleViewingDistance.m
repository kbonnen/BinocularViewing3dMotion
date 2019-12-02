%% View the model results for a single viewing distance / speed
%
% Note that there are some sample model results provided in the
% model_results folder.
%
% This code plots the model predictions and the model error with
% 95% confidence intervals. 
%
% 

speed = 5;
ecc = 0;
vd = 3;

% load model results
fn = sprintf('model_results/decoding_opt_czuba_xz_velocity_speed_%i_ecc_%ivd_%i_N_236', speed, ecc, vd);
load(fn);

figure(3);
clf;
subplot(121); hold; % subplot contains model predictions

purple = [0.5961    0.3059    0.6392];

% convert to radians
theta = rad2deg(theta);
estimates = (rad2deg(estimates));

plot(theta,(mod(squeeze(estimates(1,:,:)),360)),'o','MarkerFaceColor',purple,'MarkerEdgeColor','k','MarkerSize',2);
plot(theta,theta,'--','Color',[.5,.5,.5],'LineWidth',1);

set(gca,'XTick',0:90:360);
xlim([-10,370])
set(gca,'YTick',0:90:360);
ylim([-10,370])
axis square
title(['Model Predictions']);
xlabel('presented motion direction (deg)');
ylabel('model prediction (deg)');

subplot(122); hold on; % subplot contains model error
% calculate error
tmp = mod(squeeze(estimates(1,:,:)),360)';
theta2 = repmat(theta',100,1);
tmp(theta2<90 & tmp>270) = tmp(theta2<90 & tmp>270)-360;
tmp(theta2>270 & tmp<90) = tmp(theta2>270 & tmp<90)+360;
df = tmp-theta';
est_m = mean(df);

plot(theta,est_m,'Color',purple,'LineWidth',1);
conf_intervals = quantile(df,[.025,.975]);
e=errorshmear(theta,est_m,conf_intervals(1,:),conf_intervals(2,:),'b');

set(gca,'XTick',0:90:360);
set(e,'LineWidth',.25);
set(e,'FaceColor',purple,'FaceAlpha',.5);
xlim([0,360])
axis square

title(['Average Model Error \newline(and 95% confidence intervals)']);
xlabel('presented motion direction (deg)');
ylabel('model error (deg)');
