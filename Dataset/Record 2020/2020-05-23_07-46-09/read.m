% Load the data from Excel
data = xlsread('Accelerometer.xlsx');

% Extract accelerometer data for each dimension
accelerationX = data(:, 2); % Replace with the actual column index
accelerationY = data(:, 3); % Replace with the actual column index
accelerationZ = data(:, 4); % Replace with the actual column index
% Assuming your accelerometer data is in accelerationX, accelerationY, accelerationZ
disp('Original Data:');
disp(accelerationX);
% Set a threshold for outliers (adjust as needed)
threshold = 2;

% Identify and remove outliers for each dimension using a different method
accelerationX_clean = removeOutliers(accelerationX, threshold);
accelerationY_clean = removeOutliers(accelerationY, threshold);
accelerationZ_clean = removeOutliers(accelerationZ, threshold);

disp('Cleaned Data:');
disp(accelerationX_clean);

% Define a function to remove outliers using a different method
% function data_clean = removeOutliers(data, threshold)
%     q1 = prctile(data, 10);
%     q3 = prctile(data, 60);
%     iqr_val = q3 - q1;
%     
%     lower_bound = q1 - threshold * iqr_val;
%     upper_bound = q3 + threshold * iqr_val;
%     
%     outliers = data < lower_bound | data > upper_bound;
%     
%     % Replace outliers with NaN or remove them based on your preference
%     data_clean = data;
%     data_clean(outliers) = NaN;
%     
%     % Alternatively, you can remove outliers completely
%     % data_clean(outliers) = [];
% end
function data_without_outliers = removeOutliers(data, threshold)
    q1 = prctile(data, 25);
    q3 = prctile(data, 75);
    iqr_value = q3 - q1;
    
    lower_bound = q1 - threshold * iqr_value;
    upper_bound = q3 + threshold * iqr_value;
    
    % Identify outliers
    outliers = data < lower_bound | data > upper_bound;
    
    % Set outliers to NaN
    data(outliers) = NaN;
    
    % Return data without outliers
    data_without_outliers = data;
end

