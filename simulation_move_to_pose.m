%% Move it all around..
% Make sure you have RTB zip file from
% http://petercorke.com/wordpress/toolboxes/robotics-toolbox
% and take note of where you extract it. 
% Update path_to_rvctools
%
% Simulated robot will move around in a matlab plot figure.
%
% See https://github.com/petercorke/robotics-toolbox-matlab README.md
% for referance.


clear all; clc;

%% Load Peter Corke
path_to_rvctools = 'C:\Users\mojo\OneDrive\Documents\MATLAB\rvctools';
addpath(genpath(path_to_rvctools))
startup_rvc
mdl_ur5;

%% Home position and present tool pose
ur5_home_joint_positions = [0, -pi/2, 0, -pi/2, 0, 0];

p = [0.8 0 0];
T = transl(p) * troty(pi/2);
ur5_present_tool_pose = ur5.ikine(T);

%% Move from home to present
qr = ur5_home_joint_positions;
qqr = ur5_present_tool_pose;
qrt = jtraj(qr, qqr, 50);
qqr_prev = qqr;

ur5.plot(qrt)

%% Move to pose, up and down on the world frame z-axis
z_min = -0.2;
z_max = 0.2;
for i=1:5
    clc
    i
    z_position = z_min + (z_max-z_min)*rand(1,1)
    p(3) = z_position;
    T = transl(p)*troty(pi/2);
    qr = qqr_prev;
    qqr = ur5.ikine(T);
    qrt = jtraj(qr, qqr, 50);
    qqr_prev = qqr;
    
    ur5.plot(qrt)
    
end
disp('done')
