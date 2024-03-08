% Define the path to the CSV file
file_path = 'D:\BTP\Dataset\Record 2020\SensorRecord2020\2020-05-23_13-17-23\Accelerometer.csv';

% Read the CSV file
acceleration_data = csvread(file_path, 1, 0); % Assuming the header is present

% Extract acceleration data
time_interval = 0.1;  % Time interval in seconds
x_acceleration = acceleration_data(1:3439, 2);
y_acceleration = acceleration_data(1:3439, 3);
temp = acceleration_data(1:3439, 4);
z_acceleration = temp - 9.8;
% Initializations
x_velocity = zeros(size(x_acceleration));
y_velocity = zeros(size(y_acceleration));
z_velocity = zeros(size(z_acceleration));

% Recursive velocity estimation
for i = 2:length(x_acceleration)
    x_velocity(i) = x_velocity(i-1) + x_acceleration(i) * time_interval;
    y_velocity(i) = y_velocity(i-1) + y_acceleration(i) * time_interval;
    z_velocity(i) = z_velocity(i-1) + z_acceleration(i) * time_interval;
end

% Segment Slope Calculation
change_points = [1; find(diff(x_acceleration) ~= 0) + 1];
for k = 2:length(change_points)
    m_k = (x_velocity(change_points(k)) - x_velocity(change_points(k-1))) / (change_points(k) - change_points(k-1));
    x_velocity(change_points(k-1):change_points(k)) = x_velocity(change_points(k-1):change_points(k-1)) - m_k * (1:length(x_velocity(change_points(k-1):change_points(k-1)))) - x_velocity(change_points(k-1));
end

% Calibration Phase
stop_start_points = find(x_velocity == 0);
for i = 1:length(stop_start_points)
    if stop_start_points(i) > 1
        m_median = median((x_velocity(stop_start_points(i-1):stop_start_points(i))));
        x_velocity(stop_start_points(i-1):stop_start_points(i)) = x_velocity(stop_start_points(i-1):stop_start_points(i)) - m_median * (1:length(x_velocity(stop_start_points(i-1):stop_start_points(i)))) - x_velocity(stop_start_points(i-1));
    end
end

% Visualize results
figure;

subplot(3, 1, 1);
plot((1:length(x_velocity))*time_interval, x_velocity);
title('X-Axis Velocity');
xlabel('Time (s)');
ylabel('Velocity');

subplot(3, 1, 2);
plot((1:length(y_velocity))*time_interval, y_velocity);
title('Y-Axis Velocity');
xlabel('Time (s)');
ylabel('Velocity');

subplot(3, 1, 3);
plot((1:length(z_velocity))*time_interval, z_velocity);
title('Z-Axis Velocity');
xlabel('Time (s)');
ylabel('Velocity');

% Adjust figure for better visualization
sgtitle('Accelerometer Velocity Estimation');


% Calculate overall speed
overall_speed = sqrt(x_velocity.^2 + y_velocity.^2 + z_velocity.^2);

% Visualize results
figure;

subplot(4, 1, 1);
plot((1:length(x_velocity))*time_interval, x_velocity);
title('X-Axis Velocity');
xlabel('Time (s)');
ylabel('Velocity');

subplot(4, 1, 2);
plot((1:length(y_velocity))*time_interval, y_velocity);
title('Y-Axis Velocity');
xlabel('Time (s)');
ylabel('Velocity');

subplot(4, 1, 3);
plot((1:length(z_velocity))*time_interval, z_velocity);
title('Z-Axis Velocity');
xlabel('Time (s)');
ylabel('Velocity');

subplot(4, 1, 4);
plot((1:length(overall_speed))*time_interval, overall_speed);
title('Overall Speed');
xlabel('Time (s)');
ylabel('Speed');

% Adjust figure for better visualization
sgtitle('Accelerometer Velocity Estimation');
 