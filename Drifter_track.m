clear all
close all
% Draw map of St Joes Bay
figure(1)
clf

% lat=[29.78 29.83];
lon=[-84.72 -84.45];
lat=[29.78 30];

% lon=[-84.71 -84.55];


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

% lon=nc_varget('/Users/Lena/Documents/Data/topography/ETOPO1_Ice_g_gmt4.grd','x');
% lat=nc_varget('/Users/Lena/Documents/Data/topography/ETOPO1_Ice_g_gmt4.grd','y');
% depth=nc_varget('/Users/Lena/Documents/Data/topography/ETOPO1_Ice_g_gmt4.grd','z');
% 
% ff1=findnear(lon,-83);
% ff2=findnear(lon,-85);
% ll1=findnear(lat,29);
% ll2=findnear(lat,30);
% 
% lon = lon(ff2:ff1);
% lat = lat(ll1:ll2);
% depth = depth(ll1:ll2,ff2:ff1);
% [lon,lat]=meshgrid(lon,lat);
load dogIsland_topo

cont=[-0.5:-0.5:-10.5];
[c,h]=m_contourf(lon,lat,depth,cont);
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
%65 182 196 
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
 %253 208 162 
 253.5 219 184
254 230 206
254.5 237.5 220.5];
%255 245 235]; 
CC=CC./255;

colormap(CC)
colorbar
set(gca,'clim',[-10.5 -1])

%%
data=importdata('Metocean_beacon.txt');
lat=dm2degrees([data(:,6) data(:,7)]);
lon=dm2degrees([data(:,8) data(:,9)]);
time=data(:,1:5);
time(:,6)=0;
time(:,3)=2017;
time=time(:,[3 1 2 4 5 6]);
Time = datenum(time);


ff1=findnear(Time,datenum(['18 May 2017 17:30:00']))
ff2=findnear(Time,datenum(['19 May 2017 09:45:00'])); ff2=ff2(1);

Time=Time(ff2:ff1)
lon=lon(ff2:ff1);
lat=lat(ff2:ff1);


vec = [datenum(['18 May 2017 18:00:00']):1/24:datenum(['19 May 2017 10:00:00'])];
CC=jet(length(vec));

% 
m_plot(lon,lat,'.k','markersize',13)
% for ii=1:length(Time);
%     ff=findnear(Time(ii),vec'); ff=ff(1);
%     m_plot(lon(ii),lat(ii),'.-','color',CC(ff,:),'markersize',13)
% end




% set(gca,'xlim',[-84.72 -84.57],'ylim',[29.78 29.85])
print -f -dpng /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/Drifter_track


%%
cd /Users/Lena/Documents/BottomDrifter/gmt/data
fid = fopen('GPS_track_18May.xy','w+')
for xdo = 1:length(lon)
    xnr = num2str(lon(xdo));
    ynr = num2str(lat(xdo));
    fprintf(fid,[xnr,' ',ynr,'\n']);
end
fclose(fid)
