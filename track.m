close all
clear all

%%
load SeaScan_iridium_5_2
metlon=lon;
metlat=lat;
mettt=time;


figure(1)
clf
hold on 
plot(metlon(1),metlat(1),'v','markersize',12,'markerfacecolor','b','markeredgecolor','b')
plot(metlon(2:3),metlat(2:3),'v','markersize',12,'markerfacecolor','r','markeredgecolor','r')
plot(metlon(4:5),metlat(4:5),'v','markersize',12,'markerfacecolor','m','markeredgecolor','m')
plot(metlon(6:7),metlat(6:7),'v','markersize',12,'markerfacecolor','g','markeredgecolor','g')
plot(metlon(8:22),metlat(8:22),'v','markersize',12,'markerfacecolor','y','markeredgecolor','y')

grid on 
%%
load metocean_iridium_5_2
plot(metlon(1:end),metlat(1:end),'.','markersize',15,'color','k')
%%

metlon=metlon(1:33);
metlat=metlat(1:33);
mettt=mettt(1:33);

%%
CC=jet(length(metlon));

figure(1)

hold on 
for ii=1:length(metlon)
    plot(metlon(ii),metlat(ii),'.','markersize',15,'color',CC(ii,:))
end
grid on 
hh=colorbar
colormap(CC);
set(gca,'clim',[1 length(metlon)])
set(hh,'Ytick',[1:1:length(metlon)])
set(hh,'Yticklabel',{'21:30','','21:26','','21:22','','21:18','','21:14','','21:10','','21:06',...
    '','21:02','','20:58','','20:54','','20:50','','20:46','','20:42','','20:38','','20:34','',...
    '20:30','','20:26',''})   

%%
load /Users/Lena/Documents/BottomDrifter/05_2_2017_Divetest/DVL_5_2_earthcoord
%% Plot pitch and roll and heading
headers=d.vl;
dd=headers(:,11:16);

% bottom=d.bt;

drift_tt=headers(1163:1291,11:16);

bx = ebx(1163:1291);
by = eby(1163:1291);

CC=flipud(CC);

plot(metlon(end),metlat(end),'+','markersize',15,'color',CC(1,:))

drift_lon=[];
drift_lat=[];

for ii=2:length(bx)
    if ii==2
        lat1=metlat(end);
        drift_lat=([drift_lat;lat1]);
        lat1 = degtorad(lat1);
        
        lon1=metlon(end);
        drift_lon=([drift_lon;lon1]);
        lon1 = degtorad(lon1);
    else
        lat1=lat2;
        lon1=lon2;
    end
    
    u = bx(ii-1);
    v = by(ii-1);
    
%     theta = mod(atan2d(v,u),360);
    theta = atan2d(v,u);    
%     convert to bearing from north
        if theta>=0 && theta<90
            theta = 90 - theta;
        elseif theta>=90 && theta<=180
            theta = theta - 90;
            theta = 90 - theta;
            theta = theta + 270;
        elseif theta<=0 && theta>=-180
            theta = abs(theta) + 90;
%             % elseif theta<=-90 && theta>=-180
%             %     theta = abs(theta) + 180;
        else
            error('Case Missig')
        end
    

    theta = degtorad(theta);
    
    
    
    SP=sqrt(u.^2 + v.^2);
    SP = SP;
    dist= SP * 30;
    
    R=6371*1000;
    
    dOverR = dist/R;

    lat2 = asin((sin(lat1) * cos(dOverR)) + (cos(lat1) * sin(dOverR) * cos(theta)));
    lat2deg = radtodeg(lat2);
    
    a = atan2((sin(theta) * sin(dOverR) * cos(lat1)),cos(dOverR) - (sin(lat1) * sin(lat2)));
    
    lon2 =  lon1 + a; 
    lon2deg = radtodeg(lon2);
    
    
    
    
    drift_lat=([drift_lat;lat2deg]);
    drift_lon=([drift_lon;lon2deg]);
    
    plot(lon2deg,lat2deg,'+k','markersize',15)
end




box on 
grid minor
title('Drifter track example April 12, 2017 10:46 - 11:14','fontsize',14,'fontweight','bold')
xlabel('Longitude')
ylabel('Latitude')
set(gca,'fontsize',12)

print -f -dpng /Users/Lena/Documents/BottomDrifter/05_2_2017_Divetest/track_example

distInMeters_start=distance(metlat(end),metlon(end),...
    drift_lat(1),drift_lon(1),6371000) 

distInMeters_end=distance(metlat(1),metlon(1),...
    drift_lat(end),drift_lon(end),6371000) 



%%    SECOND EXAMPLE
clear all
%%
load SeaScan_iridium_5_2
metlon=lon(9:end-4);
metlat=lat(9:end-4);
mettt=time(9:end-4,:);

%%
CC=jet(length(metlon));

figure(1)
% clf
hold on 
for ii=1:length(metlon)
    plot(metlon(ii),metlat(ii),'.','markersize',15,'color',CC(ii,:))
end
grid on 


%%
load /Users/Lena/Documents/BottomDrifter/05_2_2017_Divetest/DVL_5_2_earthcoord
%% Plot pitch and roll and heading
headers=d.vl;
dd=headers(:,11:16);

% bottom=d.bt;

drift_tt=headers(2461:2791,11:16);

bx = ebx(2461:2791);
by = eby(2461:2791);

CC=flipud(CC);

plot(metlon(1),metlat(1),'+','markersize',15,'color',CC(1,:))

drift_lon=[];
drift_lat=[];

for ii=2:length(bx)
    if ii==2
        lat1=metlat(1);
        drift_lat=([drift_lat;lat1]);
        lat1 = degtorad(lat1);
        
        lon1=metlon(1);
        drift_lon=([drift_lon;lon1]);
        lon1 = degtorad(lon1);
    else
        lat1=lat2;
        lon1=lon2;
    end
    
    u = bx(ii-1);
    v = by(ii-1);
    
%     theta = mod(atan2d(v,u),360);
    theta = atan2d(v,u);    
%     convert to bearing from north
        if theta>=0 && theta<90
            theta = 90 - theta;
        elseif theta>=90 && theta<=180
            theta = theta - 90;
            theta = 90 - theta;
            theta = theta + 270;
        elseif theta<=0 && theta>=-180
            theta = abs(theta) + 90;
%             % elseif theta<=-90 && theta>=-180
%             %     theta = abs(theta) + 180;
        else
            error('Case Missig')
        end
    

    theta = degtorad(theta);
    
    
    
    SP=sqrt(u.^2 + v.^2);
    SP = SP;
    dist= SP * 30;
    
    R=6371*1000;
    
    dOverR = dist/R;

    lat2 = asin((sin(lat1) * cos(dOverR)) + (cos(lat1) * sin(dOverR) * cos(theta)));
    lat2deg = radtodeg(lat2);
    
    a = atan2((sin(theta) * sin(dOverR) * cos(lat1)),cos(dOverR) - (sin(lat1) * sin(lat2)));
    
    lon2 =  lon1 + a; 
    lon2deg = radtodeg(lon2);
    
    
    
    drift_lat=([drift_lat;lat2deg]);
    drift_lon=([drift_lon;lon2deg]);
    
    plot(lon2deg,lat2deg,'+k','markersize',15)
end




box on 
grid minor
title('Drifter track example April 12, 2017 10:46 - 11:14','fontsize',14,'fontweight','bold')
xlabel('Longitude')
ylabel('Latitude')
set(gca,'fontsize',12)

print -f -dpng /Users/Lena/Documents/BottomDrifter/05_2_2017_Divetest/track_example

distInMeters_start=distance(metlat([1 end]),metlon([1 end]),...
    drift_lat([1 end]),drift_lon([1 end]),6371000) 

