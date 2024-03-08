% Function to compute homogeneous transformation matrix from D-H parameters



% Define D-H parameters for a 2-DOF planar robot
% Modify these parameters based on your robot's structure
a1 = 1; d1 = 0; alpha1 = 0; theta1 = sym('theta1');
a2 = 1; d2 = 0; alpha2 = 0; theta2 = sym('theta2');

% Define symbolic joint variables
q = [theta1; theta2];

% Compute homogeneous transformation matrices
A1 = dhparam2matrix(a1, alpha1, d1, theta1);
A2 = dhparam2matrix(a2, alpha2, d2, theta2);

% Compute forward kinematics
T = A1 * A2;

% Display the transformation matrix
disp('Transformation matrix T:');
disp(T);

% Compute the Jacobian matrix for velocity kinematics
J = jacobian(T(1:2, 4), q);

% Display the Jacobian matrix
disp('Jacobian matrix J:');
disp(J);

% Simulate the robot's motion
time = 0:0.1:2*pi;  % Time vector
theta1_vals = sin(time);
theta2_vals = cos(time);

% Initialize figure for animation
figure;

for i = 1:length(time)
    % Update joint angles
    theta1_val = theta1_vals(i);
    theta2_val = theta2_vals(i);
    
    % Update transformation matrix
    T_val = subs(T, {theta1, theta2}, {theta1_val, theta2_val});
    
    % Extract end-effector position
    end_effector_pos = T_val(1:2, 4);
    
    % Plot robot links
    plot([0, T_val(1, 4)], [0, T_val(2, 4)], 'k-o', 'LineWidth', 2);
    hold on;
    
    % Plot end-effector position
    plot(end_effector_pos(1), end_effector_pos(2), 'ro', 'MarkerSize', 8);
    
    % Set axis limits
    axis equal;
    xlim([-2, 2]);
    ylim([-2, 2]);
    
    % Update plot
    drawnow;
    
    % Pause for animation smoothness
    pause(0.1);
    
    % Clear previous plot
    cla;
end
