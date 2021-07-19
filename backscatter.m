clear all
close all
%%
bb=0.67+0.88+0.3:0.3:8;

load DVL_5_18
headers=d.vl;
bottom=d.bt;  bottom = bottom(846:2851,:);

time=headers(846:2851,11:16);
time=datenum(time);



echo = d.echo;
echo = nanmean(echo(:,:,4),3);
echo = echo(846:2851,:);
echo = transpose(echo);

load CTD_5_18
for ii=1:size(time)
    ff=findnear(time(ii),CTD(:,end));
    pres(ii)=CTD(ff,3);
end
bot=nanmean(bottom(:,1:4),2);
bot = bot + pres';

for ii = 1:size(echo,2)
    ff = findnear(bb,bot(ii));
   echo(ff-1:end,ii)=NaN;
end

%% SMOOTH w data
secho = [];
ntime = [];
ct=0;
for ii = 6:10:size(echo,2)
    ct=ct+1;
    if ii>=size(echo,2)-3
       secho(:,ct) = nanmean(echo(:,ii-5:end),2);
    else
       secho(:,ct) = nanmean(echo(:,ii-5:ii+9),2);

    end
    ntime(ct) = time(ii);
end  

[xx,yy] = meshgrid(ntime,bb);


% SC=[94 79 162	
% 72 107.5 175.5	
% 50 136 189	
% 076 165 177		
% 102 194 165
% 136.5 207.5 164.5 
% 171 221 164	
% 200.5 233 158
% 230 245 152	
% 242.5 250 171.5
% 255 255 191
% 254.5 239.5 165	
% 254 224 139
% 253.5 199 118
% 253 174 97   
% 248.5 141.5 82 
% 244 109 67  
% 228.5 85.5 73 
% 213 62 79  
% 185.5 31.5 72.5];
% SC = SC./255;
% 

SC=[180 0 160
144 0 160    
60 0 160   
0 140 255   
0 163 255   
0 187 255   
0 220 255  
119 255 135  
183 255 71   
215 255 42   
247 255 7   
255 220 0    
255 175 0    
255 145 0    
255 122 0     
255 99 0     
235 0 0      
160 0 0
110 0 0  
60 0 0];
SC=SC./255;

figure(1)
clf
hold on 

pcolor(xx,yy,secho(1:21,:))
axis ij
shading flat
ax=axis;

load CTD_5_18
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

set(gca,'clim',[40 65],'ylim',[1 8])
colorbar
colormap(SC)


box on 
set(gca,'xlim',[time(1) time(end)],'ylim',[1.5 8])
text(time(1)+0.4,7,'Backscatter Amplitude','color','w','fontsize',13,'fontweight','bold')
datetick('x',15,'keeplimits','keepticks')
text(time(1)+0.02,9,'18 May 2017','fontsize',12)
set(gca,'fontsize',12)
% set(gca,'clim',[0 0.5])
ylabel('Depth [m]')


print -f -dpng /Users/Lena/Documents/BottomDrifter/Matlab/plots/backscatter