%%
clear all

load /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/DVL_5_18

%% Plot pitch and roll and heading
headers=d.vl;
bottom=d.bt;
vel=d.vel;

bottom_u=bottom(:,5);
bottom_v=bottom(:,6);

uu=vel(:,:,1);
vv=vel(:,:,2);
ww=vel(:,:,3);


time=headers(:,11:16);
time=datenum(time);

%%
for ii=1:size(uu,2);
    uu(:,ii) = uu(:,ii) - bottom_u;
    vv(:,ii) = vv(:,ii) - bottom_v;
end

bb=0.67+0.88+0.15:0.3:31;
bb=bb(1:30);

sp=sqrt(uu.^2+vv.^2);


% sp=sp(1:18,:);
sp=transpose(sp);

[xx,yy]=meshgrid(time,bb);


load CTD_5_18
CTD(:,end) = CTD(:,end) + (1/24);

for ii=1:size(time)
    ff=findnear(time(ii),CTD(:,end));
    pres(ii)=CTD(ff,3);
end

for ii=1:size(yy,2)
    ny(:,ii)=yy(:,ii)+pres(ii);
end


 
 
fig=figure(4)
clf
hold on 

pcolor(xx,ny,sp)
axis ij
shading flat
colormap(jet)
colorbar

ax=axis;
hold on
 
bot=nanmean(bottom(:,1:4),2);
bot = bot + pres';

ff=find(~isnan(bot));
bot=bot(ff);
timebot=time(ff);

yb=[bot;ax(4);ax(4);bot(1)];
xb=[timebot;timebot(end);timebot(1);timebot(1)];
fill(xb,yb,[.7 .7 .7])
 


set(gca,'clim',[0 0.3])

ylabel('Depth [m]')
set(gca,'ylim',[1 8.5],'xtick',[xx(1,1):.04:xx(1,end)],'xaxisLocation','top')
datetick('x',13,'keeplimits','keepticks')
title({'Adjusted Speed, May 18 Divetest'})
set(gca,'fontsize',10,'fontweight','bold')
grid on 
grid minor
set(gca,'xlim',[datenum('18 May 2017 17:30:00') datenum('19 May 2017, 10:45:05')])


set(fig, 'PaperPositionMode', 'auto')

print -f -dpng /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/adjSpeed_adjBot



cd /Users/Lena/Documents/BottomDrifter/gmt/data
fid=fopen('Bottom_clearance_bottom2.xy','w+')
for xdo = 1:length(yb)
    dd=datevec(xb(xdo));
    year=num2str(dd(1));
    mth=num2str(dd(2));
    if dd(2)<10
        mth=['0',mth];
    end
    day=num2str(dd(3));
    if dd(3)<10
        day=['0',day];
    end
    hour=num2str(dd(4));
    if dd(4)<10
        hour=['0',hour];
    end
    min=num2str(dd(5));
    if dd(5)<10
        min=['0',min];
    end
    
    xnr=[year,'-',mth,'-',day,'T',hour,':',min];
       ynr = num2str(yb(xdo));
    fprintf(fid,[xnr,' ',ynr,'\n']);
end

