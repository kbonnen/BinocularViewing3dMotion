function[nll] = negPopLogLikelihood(motion,f,r,params)
% function[nll] = negPopLogLikelihood(motion,f,r,params)
%
%   motion: (e.g., specifies [direction, speed] for xz motion)
%   f: tuning curve function handle
%   r: "neural responses"
%   params: parameters for tuning curves
%
%   nll: negative loglikelihood
%
%   see Graf, Kohn, Jazayeri, & Movshon (2011)
%

motion(2) = exp(motion(2));
ftemp = f(motion,params); % calculate tuning curve responses to particular motion
weights = log(ftemp);
ll = bsxfun(@times,weights,r) - ftemp - repmat(logfactorial(r),1,size(motion,1));
nll = -sum(ll);
