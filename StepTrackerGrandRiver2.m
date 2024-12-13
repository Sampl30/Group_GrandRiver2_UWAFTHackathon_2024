clear  % Clears the workspace, removing all variables and functions that may have been defined previously.

% Load the data stored in 'ExampleData.mat' into the workspace. This file contains data structures for Position and Acceleration.
load('ExampleData.mat');

% Extract the latitude, longitude, and timestamps from the Position data structure.
lat = Position.latitude;  % Latitude values in degrees.
lon = Position.longitude;  % Longitude values in degrees.
positionDatetime = Position.Timestamp;  % Timestamps of position data (datetime format).

% Extract the X, Y, Z acceleration components and their respective timestamps from the Acceleration data structure.
Xacc = Acceleration.X;  % X component of acceleration (in m/s^2).
Yacc = Acceleration.Y;  % Y component of acceleration (in m/s^2).
Zacc = Acceleration.Z;  % Z component of acceleration (in m/s^2).
accelDatetime = Acceleration.Timestamp;  % Timestamps of acceleration data (datetime format).

% Convert the datetime arrays (positionDatetime and accelDatetime) to linear time in seconds since the first timestamp
positionTime = seconds(positionDatetime - positionDatetime(1));  % Time in seconds since the first position timestamp.
accelTime = seconds(accelDatetime - accelDatetime(1));  % Time in seconds since the first acceleration timestamp.

earthCirc = 24901;  % Earth's circumference in miles (though not used in the rest of the code, possibly for reference).
totaldis = 0;  % Initialize the total distance to 0. This will be updated as the distance between consecutive position points is calculated.

% Loop through the data points (excluding the last one) and calculate the distance between consecutive latitudes and longitudes.
for i = 1:(length(lat)-1)  % Loop through all latitude and longitude pairs, up to the second-to-last point.
    lat1 = lat(i);  % Latitude of the current point.
    lat2 = lat(i+1);  % Latitude of the next point.
    lon1 = lon(i);  % Longitude of the current point.
    lon2 = lon(i+1);  % Longitude of the next point.

    % The `distance` function calculates the distance between two points on Earth given their latitudes and longitudes.
    degDis = distance(lat1, lon1, lat2, lon2);  % Distance between the two points in miles.

    % Accumulate the distance calculated between each pair of points into the total distance.
    totaldis = totaldis + degDis;  % Add the distance from the current pair of points to the total distance.
end

% Average stride length in feet (assumed for the user). This will be used to estimate the number of steps.
stride = 2.5;  % Average stride length in feet.

% Convert the total distance from miles to feet (5280 feet = 1 mile).
totaldis_ft = totaldis * 5280;  % Convert the distance to feet.

% Calculate the total number of steps taken based on the total distance traveled and the assumed stride length.
steps = totaldis_ft / stride;  % Divide the total distance (in feet) by the stride length to calculate the number of steps.

% Display the results: Total distance in miles and the number of steps taken.
disp(['The total distance traveled is: ', num2str(totaldis), ' miles']);  % Display the total distance in miles.
disp(['You took ', num2str(steps), ' steps']);  % Display the total number of steps.

% Plot the acceleration data for each of the X, Y, and Z components over time (accelTime).
plot(accelTime, Xacc);  % Plot the X acceleration vs. time.
hold on;  % Keep the current plot so that additional plots can be overlaid on it.
plot(accelTime, Yacc);  % Plot the Y acceleration vs. time.
plot(accelTime, Zacc);  % Plot the Z acceleration vs. time.
hold off;  % Release the plot hold, so no more plots are added to the current figure.

% The following code appears redundant, as the same set of plots is repeated multiple times. However, it's explaining how to modify the plot.

% Plot the acceleration data again with an x-axis limit set between 0 and 50 seconds.
plot(accelTime, Xacc);  % Plot X acceleration again.
hold on;  % Keep the current plot.
plot(accelTime, Yacc);  % Plot Y acceleration again.
plot(accelTime, Zacc);  % Plot Z acceleration again.
xlim([0 50]);  % Set the x-axis limit between 0 and 50 seconds (focus on the first 50 seconds).
hold off;  % Release the plot hold again.

% Plot the acceleration data a third time with the same x-axis limit of 0 to 50 seconds.
plot(accelTime, Xacc);  % Plot X acceleration again.
hold on;  % Keep the current plot.
plot(accelTime, Yacc);  % Plot Y acceleration again.
plot(accelTime, Zacc);  % Plot Z acceleration again.
xlim([0 50]);  % Again, set the x-axis limit between 0 and 50 seconds.
hold off;  % Release the plot hold once more.

% Add a legend to the plot to label each acceleration component (X, Y, Z).
legend('X Acceleration', 'Y Acceleration', 'Z Acceleration');  % Show legend indicating which line corresponds to each axis.

% Label the x-axis as "Time (s)" and the y-axis as "Acceleration (m/s^2)".
xlabel('Time (s)');  % Label for the x-axis (time in seconds).
ylabel('Acceleration (m/s^2)');  % Label for the y-axis (acceleration in meters per second squared).

% Set the title of the plot to "Acceleration Data Vs. Time".
title('Acceleration Data Vs. Time');  % Set the plot title.
