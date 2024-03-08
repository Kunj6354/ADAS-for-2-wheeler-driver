% Load data from file
file_path = 'D:\BTP\Dataset\Record 2020\SensorRecord2020\2020-05-23_07-46-09\Accelerometer.csv';
data = readmatrix(file_path);

% Assuming data is a 103252 x 4 double array
time = data(1:6878, 2);  % Extract time column
acceleration = data(1:6878, 3:5);  % Extract x, y, z acceleration columns

% Plotting
figure;

% Plotting x-axis acceleration
subplot(3, 1, 1);
plot(time, acceleration(:, 1), 'b');
title('X-axis Acceleration');
xlabel('Time (ms)');
ylabel('Acceleration (m/s^2)');

% Plotting y-axis acceleration
subplot(3, 1, 2);
plot(time, acceleration(:, 2), 'g');
title('Y-axis Acceleration');
xlabel('Time (ms)');
ylabel('Acceleration (m/s^2)');

% Plotting z-axis acceleration
subplot(3, 1, 3);
plot(time, acceleration(:, 3), 'r');
title('Z-axis Acceleration');
xlabel('Time (ms)');
ylabel('Acceleration (m/s^2)');

% Adjusting plot layout
sgtitle('Accelerometer Data Visualization');
