function[y] =f_vonmisespdf(x,p)
% function[y] =f_vonmisespdf(x,p)
%
% binocular response (spike counts) to xz motion direction (using double vonMises)
% 
% x - one column: xz direction
% p - 4 columns: 1) mu: mean for vonMises; 2) K:kappa for vonMises; 
%       3/4) amplitudes for double vonMises peaks
% 

mu = p(:,1);
K = p(:,2);
a1 = p(:,3);
a2 = p(:,4);

X = repmat(x(:,1),1,size(p,1))'; % make a stimulus column for each neuron
y = a1.*exp(K.*cos(X-mu)) + a2.*exp(K.*cos(X-mu-pi));