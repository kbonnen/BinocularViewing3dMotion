function [logfn]=logfactorial(n)
% function [logfn]=logfactorial(n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function evaluates the logarithm of n! with absolute accuracy of 1e-12 or better, and
% relative accuracy of 1e-15 or better. The following codes employ Stirling's integration 
% formula of Gamma function.

% Input parameters:
% n - the positive integer to be evaluated;

% Output parameters:
% logfn - the logrithm value of n!

% Note: 
%(1)if n<171, the value of log(n!) can be computed with high accuracy by Matlab itself;
%(2) n doesn't have to be an integer.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% see link below for original source code
% https://www.mathworks.com/matlabcentral/fileexchange/33687-log-factorial-of-large-positive-numbers
%
% Copyright (c) 2011, Zun Huang
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% * Redistributions of source code must retain the above copyright notice, this
%   list of conditions and the following disclaimer.
% 
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


% format long;

logfn = nan(size(n));
logfn(n<=170) = log(factorial(n(n<=170)));

% if  (n <= 170 ) 
%      logfn=log(factorial(n));
% else

other = n(n>170);
  
if ~isempty(other)
    eps=1e-18; % Preset accuracy for numerical evalueated log(n!) from Stirling's formula
    N=1e5; % Number of integration points in the numerical integral
    Lm=(1/2/pi)*log(1+1/(4*eps)); % Upper bound of the integral determined by the 'eps'
    t=Lm/N:Lm/N:(1-1/N)*Lm;

    g=2*atan(bsxfun(@rdivide,t,(other+1)))./repmat(exp(2*pi.*t)-1,length(other),1); % Integrand function in Stirling's integration formula

    % Multiplication coefficients of Simpson's open formula of forth-order 
    coe=ones(N-1,1); 
    coe(1,1)=55/24;
    coe(2,1)=-1/6;
    coe(3,1)=11/8;
    coe(N-3,1)=11/8;
    coe(N-2,1)=-1/6;
    coe(N-1,1)=55/24;


    logfn(n>170)=0.5*log(2*pi)+(other+0.5).*log(other+1)-other-1+g*coe*(Lm/N); 

end






