% Read the CSV file
data = readtable('sensors_readings.csv');

% Skip the first 40 rows
data = data(54:end, :);

% Columns in the data
sensorID_col = 'sensor_id';
timestamp_col = 'recorded_at';
value_col = 'value';
sensorType_col = 'sensor_type';

% Get unique sensor types
uniqueSensorTypes = unique(data.(sensorType_col));

% Plot data for each sensor type
for i = 1:length(uniqueSensorTypes)
    sensorType = uniqueSensorTypes{i};
    sensorData = data(strcmp(data.(sensorType_col), sensorType), :);
    
    % Get unique sensor IDs for this type
    uniqueSensors = unique(sensorData.(sensorID_col));
    
    % Create a new figure for this sensor type
    figure;
    hold on;
    for j = 1:length(uniqueSensors)
        sensorID = uniqueSensors(j); % Sensor IDs are numeric
        singleSensorData = sensorData(sensorData.(sensorID_col) == sensorID, :);
        
        % Plot values over time
        plot(singleSensorData.(timestamp_col), singleSensorData.(value_col), ...
            'DisplayName', ['Sensor ' num2str(sensorID)]);
    end
    
    % Add legend and labels
    legend('show');
    xlabel('Time');
    ylabel('Sensor Value');
    title(['Sensor Type: ' sensorType]);
    hold off;
end
