function[resp] = f_binocularTuning_linear(x,params)
% function[resp] = f_binocularTuning_extendedLinear(x,params)
%
% binocular response (spike counts) to xz motion direction (using linear combination)
% 
% x - first column = direction, second column = speed
% params - 5 cells;  1) parameters for left eye's log Gaussian speed tuning
% 2) parameters for right eye's log Gaussian speed tuning, 3) coefficients
% for linear combination of the left and right eye response, 4) viewing
% distance, 5) eccentricity 
%

theta = x(:,1);     % direction
m = x(:,2);         % speed
coeff = params{3};  % coefficients for linear combination
a = coeff(:,1);     % right eye's coefficient
b = coeff(:,2);     % left eye's coefficient

% calculate monocular speed in left and right eye.
if length(params)==3 % if you don't provide viewing distance/eccentricity it assumes vd = 3.25 cm and ecc = 0
    m_z = 3.25;
    m_x = 0;
    ipd = 6.5;
else
   
   m_z = params{4}; % motion location; viewing distance
   m_x = params{5}; % motion location; eccentricity
   ipd = params{6};
end

vx  = cos(theta).*m;
vz = sin(theta).*m;
speed_l =  (vx*m_z - vz.*(m_x+ipd/2))./((m_x+ipd/2)^2+m_z^2);  % angular speeds; these can be derived by taking the derivative of the angular relationship 
speed_r =  (vx*m_z - vz.*(m_x-ipd/2))./((m_x-ipd/2)^2+m_z^2);  % check out monocular_velocity_derivation/derivation.pdf for derivation


% determine monocular responses
fL = doubleLogNormal_multi(speed_l,params{1});
fR = doubleLogNormal_multi(speed_r,params{2});

% linear combination of monocular responses
resp = a.*fR+ b.*fL; 
