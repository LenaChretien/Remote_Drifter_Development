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


ff1=findnear(Time,datenum(['18 May 2017 18:10:00']))
ff2=findnear(Time,datenum(['19 May 2017 10:45:00'])); ff2=ff2(1);

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
m_plot(lon,lat,'-b')

Time = flipud(Time);
lon = flipud(lon);
lat = flipud(lat);
%%
load DVL_5_18
headers=d.vl;
bottom=d.bt;
vel=d.vel;
% 
% bottom_u=-bottom(:,6);
% bottom_v=bottom(:,5);

% uu=-vel(:,:,1);
% vv=vel(:,:,2);
% ww=vel(:,:,3);

bottom_u = - bottom(:,6);
bottom_v = bottom(:,5);


vv=vel(:,:,1);  
uu=vel(:,:,2); 
ww=vel(:,:,3); 




%
for ii=1:size(uu,2);
    uu(:,ii) = uu(:,ii) + bottom_u;
    vv(:,ii) = vv(:,ii) - bottom_v;
end


time=headers(:,11:16);
time=datenum(time);
ff=findnear(time,datenum(['18 May 2017 18:10:00']))
ff2=findnear(time,datenum(['19 May 2017 10:45:00'])); ff2=ff2(1);
uu = uu(ff:ff2,:);
vv = vv(ff:ff2,:);
bottom = bottom(ff:ff2,:);
time = time(ff:ff2);


% 
% n = 12;
% bue = zeros(length(uu),1);
% bvn = zeros(length(vv),1);
% for i = 1:length(uu)
%     n1 = max(1, i-n);
%     n2 = min(length(uu),i+n);
%     bue(i) = mean(uu(n1:n2)); 
%     
%     bvn(i) = mean(vv(n1:n2));
% end



bb=0.67+0.88+0.15:0.3:31;
bb=bb(1:30);

load CTD_5_18
CTD(:,end) = CTD(:,end) + (1/24);

for ii=1:size(time)
    ff=findnear(time(ii),CTD(:,end));
    pres(ii)=CTD(ff,3);
end

bot=nanmean(bottom(:,1:4),2);
bot = bot + pres';
for ii=1:length(bot)
    ff=find(bb>=bot(ii),1);
    uu(ii,ff-1:end)=NaN;
    vv(ii,ff-1:end)=NaN;
end


% nuu = [];
% nvv = [];
% ntime = [];
% ct=0;
% for ii = 2:4:length(uu)
%     ct=ct+1;
%     if ii>=length(uu)-1
%         nuu(:,ct) = nanmean(uu(ii-1:end,:),1)';
%         nvv(:,ct) = nanmean(vv(ii-1:end,:),1)';
%     else
%        nuu(:,ct) = nanmean(uu(ii-1:ii+2,:),1)';
%        nvv(:,ct) = nanmean(vv(ii-1:ii+2,:),1)';
% 
%     end
%     ntime(ct) = time(ii);
% end

% uu=[]
% vv=[];
% for ii=1:30
%     UU=interp1(ntime,nuu(ii,:),Time);
%     VV=interp1(ntime,nvv(ii,:),Time);
%     uu(:,ii)=UU;
%     vv(:,ii)=VV;
% end

nuu=[]
nvv=[];
for ii=1:30
    UU=interp1(time,uu(:,ii),Time);
    VV=interp1(time,vv(:,ii),Time);
    nuu(:,ii)=UU;
    nvv(:,ii)=VV;
end



uu_surf = nuu(:,1:5); uu_surf = nanmean(uu_surf,2);
vv_surf = nvv(:,1:5); vv_surf = nanmean(vv_surf,2);

uu_mid = nuu(:,6:12); uu_mid = nanmean(uu_mid,2);
vv_mid = nvv(:,6:12); vv_mid = nanmean(vv_mid,2);

uu_deep = nuu(:,13:end); uu_deep = nanmean(uu_deep,2);
vv_deep = nvv(:,13:end); vv_deep = nanmean(vv_deep,2);
for ii=1:length(Time) 
        m_quiver(lon(ii),lat(ii),uu_mid(ii),vv_mid(ii),0.02,'color','r','linewidth',0.2,'MaxHeadSize',0.7)

    m_quiver(lon(ii),lat(ii),uu_surf(ii),vv_surf(ii),0.02,'color','k','linewidth',0.2,'MaxHeadSize',0.7)
%    m_quiver(lon(ii),lat(ii),uu_deep(ii),vv_deep(ii),0.025,'color','g')
end

    
% 
% for ii=1:length(Time)    
%     m_quiver(lon(ii),lat(ii),nub(ii),nvb(ii),0.025,'color','k')
% end

       
    



%%
print -f -dpng /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/Drifter_track
