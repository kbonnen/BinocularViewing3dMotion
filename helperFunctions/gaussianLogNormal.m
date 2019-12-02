function[tc] = gaussianLogNormal(x,params)
% function[tc] = gaussianLogNormal(x,params)
%
%  Tuning curve: vonMises for direction and log-Gaussian for speed
% 
%  x - [xy direction (radians), speed]
%  params - 7 column matrix (each row represents a neuron). Columns: 1)
%  speed preference, 2) baseline response, 3) variance (sigma), 4) preferred direction
%  5) vonMises K, 6) amplitude in preferred direction, 7) amplitude in
%  anti-preferred direction (determines directionality of neuron)
%
%
num = size(params,2);
nStim = size(x,1);
X = repmat(x(:,2),1,num);

sp = repmat(params(1,:),nStim,1); % speed preference 
R0 = repmat(params(2,:),nStim,1);  % baseline firing rate
sig = repmat(params(3,:),nStim,1); % sigma (tuning width)
mu = log(abs(sp))+sig.^2;       % mean of log-Gaussian (function of speed-preference and sigma)

f = f_vonmisespdf(x(:,1),params(4:7,:)');

tc = f'.*lognpdf(X,mu,sig)./lognpdf(sp,mu,sig);
tc = tc + R0; % add the baseline firing rate
tc = tc';