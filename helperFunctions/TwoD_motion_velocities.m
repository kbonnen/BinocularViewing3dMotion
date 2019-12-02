function [velL, velR] = TwoD_motion_velocities(objectZ, objectX, objectDirection, objectSpeed, iopd)%,fixationZ,fixationX
% function [velL, velR] = TwoD_motion_velocities(objectZ, objectX, objectDirection, objectSpeed, iopd)%,fixationZ,fixationX
% 
% Converts xz object direction/location to corresponding left/right eye
% velocities.

%object
vx=cosd(objectDirection).*objectSpeed;
vz=sind(objectDirection).*objectSpeed;
z=objectZ;

%left eye
x=objectX + iopd/2;
velL= (vx.*z - vz.*x)./(x.^2+z.^2);

x=objectX - iopd/2;
velR= (vx.*z - vz.*x)./(x.^2+z.^2);