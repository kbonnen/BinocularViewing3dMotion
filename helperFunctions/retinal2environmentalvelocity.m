function[theta,m] = retinal2environmentalvelocity(vL,vR,x,z,ipd)
% function[theta,m] = retinal2environmentalvelocity(vL,vR,x,z,ipd)
%
% converts to environmental velocity (theta,m) given left and right eye retinal
% velocities (vL,vR), motion location (x,z), and interpupillary distance
% (ipd).

A = [z, -(x+ipd/2); z, -(x-ipd/2)];
b = [ ((x+ipd/2)^2+z^2)*vL; ((x-ipd/2)^2+z^2)*vR];
env_vel = A\b;
theta = atan2d(env_vel(2),env_vel(1));
m = sqrt(sum(env_vel.^2));
