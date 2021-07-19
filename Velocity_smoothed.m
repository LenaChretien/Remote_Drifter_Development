clear all
bb=0.67+0.88+0.3:0.3:8;
%% Calculate shear
load /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/DVL_5_18

% Plot pitch and roll and heading
headers=d.vl;
bottom=d.bt;  bottom = bottom(846:2851,:);
vel=d.vel;

bottom_u = -bottom(:,6);
bottom_v = bottom(:,5);


vv=vel(:,:,1);  vv = vv(846:2851,:);
uu=vel(:,:,2);  uu = uu(846:2851,:);
ww=vel(:,:,3);  ww = ww(846:2851,:);

time=headers(846:2851,11:16);
time=datenum(time);

%
for ii=1:size(uu,2);
    uu(:,ii) = uu(:,ii) + bottom_u;
    vv(:,ii) = vv(:,ii) - bottom_v;
end


sp = sqrt(uu.^2 + vv.^2);
sp = transpose(sp);
uu = transpose(uu);
vv = transpose(vv);
ww = transpose(ww);

% SHEAR
sp_shear = [];
uu_shear = [];
vv_shear = [];
for ii = 1:size(sp,2)
    sh = diff(sp(:,ii),1);
    sp_shear(:,ii) = sh;
    
    sh = diff(uu(:,ii),1);
    uu_shear(:,ii) = sh;
    
    sh = diff(vv(:,ii),1);
    vv_shear(:,ii) = sh;
end
sp_S2 = sp_shear.^2;
uu_S2 = uu_shear.^2;
vv_S2 = vv_shear.^2;
%%
suu = [];
svv = [];
ntime = [];
ct=0;
for ii = 6:10:size(vv,2)
    ct=ct+1;
    if ii>=size(vv,2)-3
       svv(:,ct) = nanmean(vv(:,ii-5:end),2);
       suu(:,ct) = nanmean(uu(:,ii-5:end),2);
    else
       svv(:,ct) = nanmean(vv(:,ii-5:ii+9),2);
       suu(:,ct) = nanmean(uu(:,ii-5:ii+9),2);
    end
    ntime(ct) = time(ii);
end    

ssp = sqrt(suu.^2 + svv.^2);


[xx,yy] = meshgrid(ntime,bb);
%%
% figure(100)
% pcolor(xx,yy,sp_S2(1:22,:));
% hold on 
% shading flat
% 
% ax=axis;
load CTD_5_18
% for ii=1:size(time)
%     ff=findnear(time(ii),CTD(:,end));
%     pres(ii)=CTD(ff,3);
% end
% bot=nanmean(bottom(:,1:4),2);
% bot = bot + pres';
% 
% ff=find(~isnan(bot));
% bot=bot(ff);
% timebot=time(ff);
% 
% yb=[bot;ax(4);ax(4);bot(1)];
% xb=[timebot;timebot(end);timebot(1);timebot(1)];
% fill(xb,yb,[.7 .7 .7])
% 
% axis ij 
% CC=colormap(gray)
% CC=flipud(CC);
% colormap(CC);
% 
% axis ij
% colorbar
% set(gca,'clim',[0 0.017])
%%
% fig=figure(2)
% clf
% hold on 
% 
% pcolor(xx,yy,uu_S2(1:22,:))
% axis ij
% shading flat
% CC = colormap(gray);
% CC = flipud(CC);
% ax=axis;
% 
% for ii=1:size(time)
%     ff=findnear(time(ii),CTD(:,end));
%     pres(ii)=CTD(ff,3);
% end
% bot=nanmean(bottom(:,1:4),2);
% bot = bot + pres';
% 
% ff=find(~isnan(bot));
% bot=bot(ff);
% timebot=time(ff);
% 
% yb=[bot;ax(4);ax(4);bot(1)];
% xb=[timebot;timebot(end);timebot(1);timebot(1)];
% fill(xb,yb,[.7 .7 .7])
%  
% 
% set(gca,'clim',[0 0.017],'ylim',[1 8])
% colorbar
% colormap(CC)



% fig=figure(3)
% clf
% hold on 
% 
% pcolor(xx,yy,vv_S2(1:22,:))
% axis ij
% shading flat
% colormap(jet)
% ax=axis;
% 
% for ii=1:size(time)
%     ff=findnear(time(ii),CTD(:,end));
%     pres(ii)=CTD(ff,3);
% end
% bot=nanmean(bottom(:,1:4),2);
% bot = bot + pres';
% 
% ff=find(~isnan(bot));
% bot=bot(ff);
% timebot=time(ff);
% 
% yb=[bot;ax(4);ax(4);bot(1)];
% xb=[timebot;timebot(end);timebot(1);timebot(1)];
% fill(xb,yb,[.7 .7 .7])
% 
% set(gca,'clim',[0 0.017],'ylim',[1 8])
% colorbar
% colormap(CC)
% 
% print -f -dpng /Users/Lena/Documents/BottomDrifter/Matlab/plots/Ri_number

%%
VC=[%85,0,25
    103,0,31
    140,12,37
178,24,43
%196,50,60
214,96,77
229,130,103
244,165,130
249,192,164
253,219,199
%251,226,211
%250,233,223
%251,240,235
%247,247,247
255 255 255
%237,242,245
228,238,244
%233,233,242
209,229,240
%177,213,231
146,197,222
106,172,208
%67,147,195
50,124,183
33,102,172
19,75,134
5,48,97];
VC=VC./255;

SC=[94 79 162	
72 107.5 175.5	
50 136 189	
076 165 177		
102 194 165
136.5 207.5 164.5 
171 221 164	
200.5 233 158
230 245 152	
242.5 250 171.5
255 255 191
254.5 239.5 165	
254 224 139
253.5 199 118
253 174 97   
248.5 141.5 82 
244 109 67  
228.5 85.5 73 
213 62 79  
185.5 31.5 72.5];
SC = SC./255;


figure(4)
clf
orient tall
subplot(3,1,2)
hold on 

pcolor(xx,yy,suu(1:21,:))
axis ij
shading flat
ax=axis;

for ii=1:size(time)
    ff=findnear(time(ii),CTD(:,end));
    pres(ii)=CTD(ff,3);
end
bot=nanmean(bottom(:,1:4),2);
bot = bot + pres';

ff=find(~isnan(bot));
bot=bot(ff);
timebot=time(ff);

yb=[bot;ax(4);ax(4);bot(1)];
xb=[timebot;timebot(end);timebot(1);timebot(1)];
fill(xb,yb,[.7 .7 .7])

set(gca,'clim',[-0.3 0.3],'ylim',[1 8])
colorbar
colormap(VC)



figure(4)
subplot(3,1,3)
hold on 

pcolor(xx,yy,svv(1:21,:))
axis ij
shading flat
ax=axis;

for ii=1:size(time)
    ff=findnear(time(ii),CTD(:,end));
    pres(ii)=CTD(ff,3);
end
bot=nanmean(bottom(:,1:4),2);
bot = bot + pres';

ff=find(~isnan(bot));
bot=bot(ff);
timebot=time(ff);

yb=[bot;ax(4);ax(4);bot(1)];
xb=[timebot;timebot(end);timebot(1);timebot(1)];
fill(xb,yb,[.7 .7 .7])

set(gca,'clim',[-0.2 0.2],'ylim',[1 8])
colorbar
colormap(VC)



figure(4)
orient tall
sub=subplot(3,1,1)
hold on 

pcolor(xx,yy,ssp(1:21,:))
axis ij
shading flat
ax=axis;

for ii=1:size(time)
    ff=findnear(time(ii),CTD(:,end));
    pres(ii)=CTD(ff,3);
end
bot=nanmean(bottom(:,1:4),2);
bot = bot + pres';

ff=find(~isnan(bot));
bot=bot(ff);
timebot=time(ff);

yb=[bot;ax(4);ax(4);bot(1)];
xb=[timebot;timebot(end);timebot(1);timebot(1)];
fill(xb,yb,[.7 .7 .7])

set(gca,'clim',[0 0.3],'ylim',[1 8])
colorbar
colormap(sub,SC)

% 
% figure(4)
% subplot(3,1,4)
% hold on 
% 
% pcolor(xx,yy,ww(1:21,:))
% axis ij
% shading flat
% ax=axis;
% 
% for ii=1:size(time)
%     ff=findnear(time(ii),CTD(:,end));
%     pres(ii)=CTD(ff,3);
% end
% bot=nanmean(bottom(:,1:4),2);
% bot = bot + pres';
% 
% ff=find(~isnan(bot));
% bot=bot(ff);
% timebot=time(ff);
% 
% yb=[bot;ax(4);ax(4);bot(1)];
% xb=[timebot;timebot(end);timebot(1);timebot(1)];
% fill(xb,yb,[.7 .7 .7])
% 
% set(gca,'clim',[-0.06 0.06],'ylim',[1 8])
% colorbar
% colormap(VC)
% 
% 



figure(4)
subplot(3,1,1)
box on 
set(gca,'xlim',[time(1) time(end)],'ylim',[1.5 8])
text(time(end)-0.15,7,'Speed [m/s]','color','w','fontsize',13,'fontweight','bold')
text(datenum(['May 18 2017 19:40:00']),1,'H','fontsize',15,'fontweight','bold')
text(datenum(['May 19 2017 03:32:00']),1,'L','fontsize',15,'fontweight','bold')
text(datenum(['May 19 2017 10:43:00']),1,'H','fontsize',15,'fontweight','bold')

datetick('x',15,'keeplimits','keepticks')
text(time(1)+0.02,9,'18 May 2017','fontsize',12)
set(gca,'fontsize',12)
% set(gca,'clim',[0 0.5])
ylabel('Depth [m]')

subplot(3,1,2)
box on 
set(gca,'xlim',[time(1) time(end)],'ylim',[1.5 8])
text(time(end)-0.15,7,'u velocity [m/s]','color','w','fontsize',13,'fontweight','bold')
datetick('x',15,'keeplimits','keepticks')
text(time(1)+0.02,9,'18 May 2017','fontsize',12)
set(gca,'fontsize',12)
ylabel('Depth [m]')


subplot(3,1,3)
box on 
set(gca,'xlim',[time(1) time(end)],'ylim',[1.5 8])
text(time(end)-0.15,7,'v velocity [m/s]','color','w','fontsize',13,'fontweight','bold')
datetick('x',15,'keeplimits','keepticks')
text(time(1)+0.02,9,'18 May 2017','fontsize',12)
set(gca,'fontsize',12)
ylabel('Depth [m]')

% 
% subplot(4,1,4)
% box on 
% set(gca,'xlim',[time(1) time(end)],'ylim',[1.5 8])
% text(time(1)+0.02,7,'w velocity [m/s]','color','w','fontsize',13,'fontweight','bold')
% datetick('x',15,'keeplimits','keepticks')
% text(time(1)+0.02,9,'18 May 2017','fontsize',12)
% set(gca,'fontsize',12)
% ylabel('Depth [m]')

fig = figure(4)
set(fig,'PaperPositionMode','Auto')

print -f -dpng /Users/Lena/Documents/BottomDrifter/Matlab/Plots/Velocity_5_18_smoothed
