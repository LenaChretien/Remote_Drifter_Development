tide_time =[2017 5 18 2 37 %0.1 feet  Low Tide
%2017 5 18 6 43 %Sunrise
2017 5 18 10 01 %1.6 feet  High Tide
2017 5 18 14 12 %1.4 feet  Low Tide
2017 5 18 19 41 %2.0 feet  High Tide
%2017 5 18 20 26 %Sunset
2017 5 19 3 32 %0.2 feet  Low Tide
%2017 5 19 6 43 %Sunrise
2017 5 19 10 43 %1.7 feet  High Tide
2017 5 19 15 45 %1.2 feet  Low Tide
%2017 5 19 20 27 %Sunset
2017 5 19 21 04 %1.9 feet  High Tide
]; %0.5 feet  Low Tide

tide_height =[0.1;1.6;1.4;2;0.2; ...
    1.7;1.2;1.9];

tide_time(:,6) = 0;
time = datenum(tide_time);

plot(time,tide_height*0.3048)


grid on 
grid minor
datetick('x',15,'keeplimits','keepticks')