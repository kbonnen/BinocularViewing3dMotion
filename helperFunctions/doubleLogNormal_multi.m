function[tc] = doubleLogNormal_multi(x,params)
% function[tc] = doubleLogNormal_multi(x,params)
%
%  Return lognormal tuning curves (i.e. response to multiple speeds) for 
%  multiple neurons at once.
% 
%  x - speeds (single column vector)
%  params - 5 column matrix (each row represents a neuron). Columns: 1)
%  speed preference, 2) baseline response, 3) variance (sigma), 4)
%  amplitude for positive speeds, 5) amplitude for negative speeds
%
%
num = size(params,2);
nx = length(x);
X = repmat(x,1,num);

sp = repmat(params(1,:),nx,1); % speed preference 
R0 = repmat(params(2,:),nx,1);  % baseline firing rate
sig = repmat(params(3,:),nx,1); % sigma (tuning width)
a1 = repmat(params(4,:),nx,1);  % amplitude (pos speed)
a2 = repmat(params(5,:),nx,1);  % amplitude (neg speed)
mu = log(abs(sp))+sig.^2;       % mean of log-Gaussian (function of speed-preference and sigma)

ipos = X>=0;
ineg = X<0;
tc = nan(size(X));

% a*lognpdf(X,mu,sig)./lognpdf(sp,mu,sig); The following two lines
% determine the responses for the positive and negative sides of the double
% log-Gaussian respectively. (normalization sets the maximum firing rate at
% the amplitude value.
tc(ipos) = a1(ipos).*lognpdf(X(ipos),mu(ipos),sig(ipos))./lognpdf(sp(ipos),mu(ipos),sig(ipos));  % COMMENT THIS!!!
tc(ineg) = a2(ineg).*lognpdf(abs(X(ineg)),mu(ineg),sig(ineg))./lognpdf(sp(ineg),mu(ineg),sig(ineg));
tc = tc + R0; % add the baseline firing rate
tc = tc';