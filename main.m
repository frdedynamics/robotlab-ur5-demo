%% Clear everything
clear; clc;

%% Config
ur5_home_joint_positions = [0, -pi/2, 0, -pi/2, 0, 0];

%% Initialize
addpath('./interface');

% Init the connection
tcpip_socket_connection = init();

% Move robot to home position 
% TODO: add start condition and execute condition
moverobotJoint(tcpip_socket_connection, ur5_home_joint_positions);
pause(10);

%% 

% Read the current joint angles
latest_joint_positions = readrobotJoint(tcpip_socket_connection);
latest_joint_commands = ur5_home_joint_positions;

if norm(latest_joint_positions-ur5_home_joint_positions,2) < 10e-06
    disp("wave..")
    toggle = 1;
    while 1
        if toggle == 1
            latest_joint_commands = [0,-pi/2,0,-pi/2,pi/4,0]
            toggle = 0;
        else 
            latest_joint_commands = [0,-pi/2,0,-pi/2,-pi/4,0]
            toggle = 1;
        end    
        
        moverobotJoint(tcpip_socket_connection, latest_joint_commands);
        pause(10);
        
        latest_joint_positions = readrobotJoint(tcpip_socket_connection);
        latest_position_error = norm(latest_joint_positions-latest_joint_commands,2);
        if latest_position_error >= 10e-06
            disp("Position is off. Abandon ship.")
            break
        end  
    end
else
    disp("UR5 not home. Abandon ship.")
end

disp("done.")