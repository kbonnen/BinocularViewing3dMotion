function[ll,weights] = popLogLikelihood(motion,f,r,params)
% function[ll, weights] = popLogLikelihood(motion,f,r,params)
%
%   motion: (e.g., specifies [direction, speed] for xz motion)
%   f: tuning curve function handle
%   r: "neural responses"
%   params: parameters for tuning curves
%
%   ll: loglikelihood
%   weights: weights calculated from tuning curves
%
%   see Graf, Kohn, Jazayeri, & Movshon (2011)
%

ftemp = f(motion,params); % calculate tuning curve responses to particular motion
weights = log(ftemp);
ll = bsxfun(@times,weights,r) - ftemp - repmat(logfactorial(r),1,size(motion,1)); 
ll = sum(ll);
