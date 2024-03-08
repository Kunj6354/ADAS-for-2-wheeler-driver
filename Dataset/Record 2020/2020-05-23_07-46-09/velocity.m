% Load the data from Excel
data = xlsread('Accelerometer.xlsx');

% Extract accelerometer data for the X-axis
accelerationX = data(:, 2); % Replace with the actual column index
accelerationZ = data(:, 4);

% Calculate time differences to estimate dt
time_msX = data(:, 1); % Assuming the time column is the second column, replace with the actual column index
time_msY = data(:, 1); % Assuming the time column is the second column, replace with the actual column index

dt = diff(time_ms) / 1000; % Convert milliseconds to seconds

% Use the median time difference as the approximate dt
dt_approx = median(dt); 
% Load the data from Excel
data = xlsread('Accelerometer.xlsx');

% Extract accelerometer data for the X-axis
accelerationX1 = data(:, 2); % Replace with the actual column index

% Assuming your data is sampled at a constant time interval dt
dt = 0.01; % Replace with your actual time interval

% Calculate velocity using cumulative sum
velocityX = cumsum(accelerationX) * dt;

% Create a new Excel file with velocity data
velocity_data = [data(:, 2), velocityX]; % Assuming you want to keep the original X-axis acceleration data
xlswrite('velocity_data.xlsx', velocity_data);
