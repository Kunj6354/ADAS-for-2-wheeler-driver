% Assuming you have loaded your accelerometer data into accelerationX, accelerationY, accelerationZ

% Check for and handle non-finite values in each dimension
accelerationX_clean = handleNonFiniteValues(accelerationX);
accelerationY_clean = handleNonFiniteValues(accelerationY);
accelerationZ_clean = handleNonFiniteValues(accelerationZ);

% Design a low-pass filter using butter
cutoffFrequency = 5; % Adjust the cutoff frequency as needed
sampleRate = 100; % Adjust the sample rate based on your data

% Ensure that cutoffFrequency is less than the Nyquist frequency
if cutoffFrequency >= sampleRate / 2
    error('Cutoff frequency must be less than the Nyquist frequency.');
end

% Normalize the cutoff frequency
normalizedCutoff = cutoffFrequency / (sampleRate / 2);

% Design the low-pass filter using butter
filterOrder = 4; % Adjust the filter order as needed
[b, a] = butter(filterOrder, normalizedCutoff, 'low');

% Apply the filter to each dimension
accelerationX_filtered = filtfilt(b, a, accelerationX_clean);
accelerationY_filtered = filtfilt(b, a, accelerationY_clean);
accelerationZ_filtered = filtfilt(b, a, accelerationZ_clean);

% Define a function to handle non-finite values
function data_clean = handleNonFiniteValues(data)
    % Replace or remove non-finite values based on your preference
    data_clean = data;
    data_clean(~isfinite(data_clean)) = 0; % Replace with 0, you can adjust this based on your needs
    % Alternatively, you can completely remove non-finite values
    % data_clean = data_clean(isfinite(data_clean));
end
