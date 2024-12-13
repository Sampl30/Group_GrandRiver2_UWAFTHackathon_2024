clear;
load('ExampleData.mat');

lat = Position.latitude;
lon = Position.longitude;
positionDatetime = Position.Timestamp;
Xacc = Acceleration.X;
Yacc = Acceleration.Y;
Zacc = Acceleration.Z;
accelDatetime = Acceleration.Timestamp;

% Convert datetime to seconds since the first timestamp
positionTime = seconds(positionDatetime - positionDatetime(1));
accelTime = seconds(accelDatetime - accelDatetime(1));

% Calculate total distance traveled
earthCirc = 24901; % Circumference of Earth in miles
totaldis = 0;

for i = 1:(length(lat)-1)
    lat1 = lat(i); % The first latitude
    lat2 = lat(i+1); % The second latitude
    lon1 = lon(i); % The first longitude
    lon2 = lon(i+1); % The second longitude

    % Haversine formula for distance
    R = 6371; % Earth radius in kilometers
    lat1 = deg2rad(lat1);
    lon1 = deg2rad(lon1);
    lat2 = deg2rad(lat2);
    lon2 = deg2rad(lon2);

    dlat = lat2 - lat1;
    dlon = lon2 - lon1;
    a = sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    degDis = R * c; % Distance in kilometers
    totaldis = totaldis + degDis; % Total distance in kilometers
end

% Convert distance to miles
totaldis_miles = totaldis * 0.621371;

% Average stride (ft) and total steps calculation
stride = 2.5; % Average stride (ft)
totaldis_ft = totaldis_miles * 5280; % Convert distance from miles to feet
steps = totaldis_ft / stride;

disp(['The total distance traveled is: ', num2str(totaldis_miles), ' miles']);
disp(['You took ', num2str(steps), ' steps']);

% Plot the acceleration data
plot(accelTime, Xacc);
hold on;
plot(accelTime, Yacc);
plot(accelTime, Zacc);
hold off;
legend('X Acceleration', 'Y Acceleration', 'Z Acceleration');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
title('Acceleration Data Vs. Time');
