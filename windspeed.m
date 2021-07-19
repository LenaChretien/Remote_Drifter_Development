data = importdata('wind.csv');

data = data(:,2:end);
time = datenum(data(:,1:6));
wind = data(:,7);

timen = [datenum(['May 18 2017 16:00:00']) : 0.0069:datenum(['May 19 2017 11:00:00'])];
windn = interp1(time,wind,timen,'linear');

figure
% subplot(2,1,1)
plot(timen,windn);
datetick('x',15,'keeplimits','keepticks')
set(gca,'xlim',[datenum('18 May 2017 17:30:00') datenum('19 May 2017, 10:46:05')])
grid on 
grid minor
box on 
ylabel('Windspeed [m/s]')
text(timen(10),-1.7,'18 May 2017','fontsize',12,'fontweight','bold')
text(timen(end-9),-1.7,'19 May 2017','fontsize',12,'fontweight','bold')
set(gca,'fontsize',12,'fontweight','bold')

print -f -dpng /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/windspeed


%%
data = importdata('baro_rain.csv');

data = data(:,2:end);
time = datenum(data(:,1:6));
baro = data(:,7);
rain = data(:,8);

timen = [datenum(['May 18 2017 16:00:00']) : 0.0069:datenum(['May 19 2017 11:00:00'])];
baron = interp1(time,baro,timen,'linear');

subplot(2,1,2)
plot(timen,baron);
datetick('x',15,'keeplimits','keepticks')
set(gca,'xlim',[datenum('18 May 2017 17:30:00') datenum('19 May 2017, 10:46:05')])
grid on 
grid minor
box on 
ylabel('Windspeed [m/s]')
text(timen(10),-1.7,'18 May 2017','fontsize',12,'fontweight','bold')
text(timen(end-9),-1.7,'19 May 2017','fontsize',12,'fontweight','bold')
set(gca,'fontsize',12,'fontweight','bold')

print -f -dpng /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/windspeed