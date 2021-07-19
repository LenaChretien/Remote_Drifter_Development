clear all
close all
% Draw map of St Joes Bay
figure(1)
clf

lat=[29.78 29.85];
lon=[-84.7178 -84.5684];

minlon=lon(1);
maxlon=lon(2);
minlat=lat(1);
maxlat=lat(2);

orient landscape
m_proj('mercator','lat',[minlat maxlat],'lon',[minlon maxlon])

m_gshhs_h('patch',[.5 .5 .5],'edgecolor','k')

m_grid
zoom on 
hold on

load dogIsland_topo
LAT = 29:0.0083:30;
LON = -85:0.0083:-83;
[LON,LAT]=meshgrid(LON,LAT);
DEPTH = interp2(lon,lat,depth,LON,LAT,'linear');


cont=[-0.3:-0.35:-8];
[c,h]=m_contourf(LON,LAT,DEPTH,cont);
m_gshhs_h('patch',[.5 .5 .5],'edgecolor','k')
m_grid
zoom on 
hold on
for loop=1:length(h)
    set(h(loop),'color','none');
end

CC=[8 29 88
    22.5 40.5 118
 37 52 148 
 %35.5 73 158
34 94 168 
31.5 119.5 180
29 145 192 
47 163.5 194
65 182 196 
96 193.5 191.5
127 205 187 
163 219 183.5
 199 233 180 
 218 240.5 178.5
 237 248 177 
 246 242.2 168.5
 255 237 160 
 254.5 232 152.5
 254 227 145 
 253.5 217.5 153.5
 253 208 162 
 253.5 219 184
254 230 206
254.5 237.5 220.5];
%255 245 235]; 
CC=CC./255;

colormap(CC)
colorbar
set(gca,'clim',[-8 -0.3])

%%
data=importdata('Metocean_beacon.txt');
lat=dm2degrees([data(:,6) data(:,7)]);
lon=dm2degrees([data(:,8) data(:,9)]);
time=data(:,1:5);
time(:,6)=0;
time(:,3)=2017;
time=time(:,[3 1 2 4 5 6]);
Time = datenum(time);


ff1=findnear(Time,datenum(['18 May 2017 23:00:00']))
ff2=findnear(Time,datenum(['19 May 2017 10:00:00'])); ff2=ff2(1);

Time=Time(ff2:ff1)
lon=lon(ff2:ff1);
lat=lat(ff2:ff1);


vec = [datenum(['18 May 2017 18:10:00']):1/24:datenum(['19 May 2017 10:45:00'])];
CC=jet(length(vec));

% 
% for ii=1:length(Time);
%     ff=findnear(Time(ii),vec'); ff=ff(1);
%     m_plot(lon(ii),lat(ii),'.-','color',CC(ff,:),'markersize',13)
% end
% 
m_plot(lon,lat,'-k')

%%
data=importdata('Metocean_beacon.txt');
lat=dm2degrees([data(:,6) data(:,7)]);
lon=dm2degrees([data(:,8) data(:,9)]);
time=data(:,1:5);
time(:,6)=0;
time(:,3)=2017;
time=time(:,[3 1 2 4 5 6]);
Time = datenum(time);


ff1=findnear(Time,datenum(['18 May 2017 23:00:00']))
ff2=findnear(Time,datenum(['19 May 2017 10:00:00'])); ff2=ff2(1);

Time=Time(ff2:ff1)
lon=lon(ff2:ff1);
lat=lat(ff2:ff1);

Time = flipud(Time);
lon = flipud(lon);
lat = flipud(lat);
% 
n = 2;
nlon = zeros(length(lon),1);
nlat = zeros(length(lat),1);
for i = 1:length(lon)
    n1 = max(1, i-n);
    n2 = min(length(lon),i+n);
    lon(i) = mean(lon(n1:n2)); 
  
    lat(i) = mean(lat(n1:n2));
end


%%
load DVL_5_18
headers=d.vl;
bottom=d.bt;
vel=d.vel;

bottom_ue=-bottom(:,6);
bottom_vn=bottom(:,5);

%%%%%%%%%%%%%%%%
% Find bad bottom data
ff=find(bottom(:,9)<=50);
if ~isempty(ff)
    bottom_ue(ff)=NaN;
    bottom_vn(ff)=NaN;
end

ff=find(bottom(:,10)<=50);
if ~isempty(ff)
   bottom_ue(ff)=NaN;
    bottom_vn(ff)=NaN;
end

ff=find(bottom(:,11)<=50);
if ~isempty(ff)
   bottom_ue(ff)=NaN;
    bottom_vn(ff)=NaN;
end

ff=find(bottom(:,12)<=50);
if ~isempty(ff)
   bottom_ue(ff)=NaN;
    bottom_vn(ff)=NaN;
end


time=headers(:,11:16);
time=datenum(time);
ff=findnear(time,datenum(['18 May 2017 23:00:00']))
ff2=findnear(time,datenum(['19 May 2017 10:00:00'])); ff2=ff2(1);
bottom_ue = bottom_ue(ff:ff2,:);
bottom_vn = bottom_vn(ff:ff2,:);
time = time(ff:ff2);
%%
figure
subplot(2,1,1)
plot(time,bottom_ue);
hold on 
subplot(2,1,2)
plot(time,bottom_vn);
%%
%adjust angles - sliding window mean
n = 12;
bue = zeros(length(bottom_ue),1);
bvn = zeros(length(bottom_vn),1);
for i = 1:length(bottom_ue)
    n1 = max(1, i-n);
    n2 = min(length(bottom_ue),i+n);
    bue(i) = mean(bottom_ue(n1:n2)); 
    
    bvn(i) = mean(bottom_vn(n1:n2));
end

subplot(2,1,1)
plot(time,bue,'k')
subplot(2,1,2)
hold on 
plot(time,bvn,'k')
%% 
clear d f ff ff1 ff2 ii p vel bottom data headers
%%
angle = atan2d(bvn,bue);
angle = 90 - angle;
ff=find(angle<0);
angle(ff) = 360 + angle(ff);

[distGPS,angleGPS]=distance(lat(1:end-1),lon(1:end-1),lat(2:end),lon(2:end),637100);

%%
nbue = [];
nbvn = [];
nang = [];
ntime = [];
ct=0;
for ii = 2:4:length(angle)
    ct=ct+1;
    if ii>=length(angle)
        nang(ct) = nanmean(angle(ii-1:end));
        nbue(ct) = nanmean(bue(ii-1:end));
        nbvn(ct) = nanmean(bvn(ii-1:end));
    else
       nang(ct) = nanmean(angle(ii-1:ii+2));
       nbue(ct) = nansum(bue(ii-1:ii+2));
       nbvn(ct) = nansum(bvn(ii-1:ii+2));

    end
    ntime(ct) = time(ii);
end


figure
plot(Time(2:end),angleGPS)
hold on 
plot(time,angle)
% plot(ntime,nang+38)
plot(ntime,nang-13.5)
 nang = nang - 13.5;
 

distGPS = sw_dist(lat,lon,'km');
distGPS = distGPS * 1000;


figure
% subplot(3,1,1)
% plot(Time(2:end),distGPS)
sp = sqrt(nbue.^2 + nbvn.^2);
% % dist = sp *120;
dist = sp * 30;


lo=lon(1);
la=lat(1);
for ii = 1:length(nang)-1
    [l1,l2]=reckon(la(ii),lo(ii),km2deg(dist(ii+1)/1000),nang(ii+1));
    la = ([la;l1]);
    lo = ([lo;l2]);
end

figure(1)
m_plot(lo,la,'-r')
%%

print -f -dpng /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/Drifter_trajectory
