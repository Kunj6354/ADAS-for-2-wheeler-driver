% Load data from file
file_path = 'D:\BTP\Dataset\Record 2020\SensorRecord2020\2020-05-23_07-46-09\Accelerometer.csv';
data = readmatrix(file_path);

% Assuming data is a 103252 x 4 double array
time = data(:, 2);  % Extract time column
acceleration = data(:, 3:5);  % Extract x, y, z acceleration columns

% Set the target sampling rate
target_sampling_rate = 50;  % Set your desired constant sampling rate in Hz

% Calculate the original sampling rate
original_sampling_rate = 1000 / mean(diff(time));  % Assuming time is in milliseconds

% Resample the data to the target sampling rate
new_time = resample(time, target_sampling_rate, round(original_sampling_rate));
new_acceleration = resample(acceleration, target_sampling_rate, round(original_sampling_rate));

% Plot the original and resampled data
figure;

subplot(2, 1, 1);
plot(time, acceleration);
title('Original Accelerometer Data');
xlabel('Time (ms)');
ylabel('Acceleration (m/s^2)');
legend('X', 'Y', 'Z');

subplot(2, 1, 2);
plot(new_time, new_acceleration);
title('Resampled Accelerometer Data (50 Hz)');
xlabel('Time (ms)');
ylabel('Acceleration (m/s^2)');
legend('X', 'Y', 'Z');

% Save the resampled data to a new file
[path, name, ext] = fileparts(file_path);
new_file_path = fullfile(path, [name '_resampled' ext]);

% Save the resampled data to the new file
resampled_data = [new_time, new_acceleration];
writematrix(resampled_data, new_file_path);
disp(['Resampled data saved to: ' new_file_path]);
