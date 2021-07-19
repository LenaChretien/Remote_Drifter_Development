clear all

load CTD_5_18

CTD=CTD(750:2878,:);
CTD(:,7)=CTD(:,7)+1/24;
figure(1)
clf
ss1=subplot(2,1,1)
hold on 
plot(CTD(:,7),CTD(:,3),'-k')

temp_vec=[27.05:0.05:28];
% CC=jet(length(temp_vec));
CC=[180 0 160
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
CC=CC./255;

for ii = 1:size(CTD,1)
    ff=findnear(CTD(ii,1),temp_vec);
    ff=ff(1);
    
    plot(CTD(ii,7),CTD(ii,3),'.','markersize',13,'markerfacecolor',CC(ff,:),'markeredgecolor',CC(ff,:))
    
end

hold on
set(gca,'xlim',[datenum('18 May 2017 17:30:00') datenum('19 May 2017, 10:46:05')])
axis ij
grid on 
grid minor
box on 
datetick('x',15','keeplimits','keepticks')

colorbar
colormap(ss1,CC)
set(gca,'clim',[27.05 28])


%%
ss2=subplot(2,1,2)
hold on 
plot(CTD(:,7),CTD(:,3),'-k')

salt_vec=[31.623:.025:32.118];
% CC=jet(length(salt_vec));
CC=[%0 50 40 
0 90 50 
17 111 58
35 132 67	
50 153 80	
65 171 93  	
92 184 107 
120 198 121	
146 209 131	
173 221 142	
195 230 153	
217 240 163
236 247 184	
255 255 204 	
255 246 204	
255 237 204	
255 237 192	
255 237 180 	
254 216 130	
254 196 79  	
217 95 14];		
%153 52 4];
CC=CC./255;

for ii = 1:size(CTD,1)
    ff=findnear(CTD(ii,5),salt_vec);
    ff=ff(1);
    
    plot(CTD(ii,7),CTD(ii,3),'.','markersize',13,'markerfacecolor',CC(ff,:),'markeredgecolor',CC(ff,:))
    
end

hold on
set(gca,'xlim',[datenum('18 May 2017 17:30:00') datenum('19 May 2017, 10:46:05')])
axis ij
grid on 
grid minor
box on 
datetick('x',15','keeplimits','keepticks')

colorbar
colormap(ss2,CC)
set(gca,'clim',[31.623 32.118])

%%
subplot(2,1,1)
title('Temperature','fontsize',15)
ylabel('Pressure')
set(gca,'fontsize',12)


subplot(2,1,2)
title('Salinity','fontsize',15)
ylabel('Pressure')
xlabel('Time')
set(gca,'fontsize',12)
text(CTD(1,7),3.8,'18 May 2017','fontsize',12)
text(CTD(end-100,7),3.8,'19 May 2017','fontsize',12)

fig=figure(1)
set(fig,'PaperPositionMode','auto')
print -f -dpng /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/CTD_Data

%%

figure(2)
clf
subplot(3,1,1:2)
[ax,hh]=plotyyy(CTD(:,7),CTD(:,1),CTD(:,7),CTD(:,5),CTD(:,7),CTD(:,4))
ylabel(ax(1),'Temperature [C]')
ylabel(ax(2),'Salinity')
grid on 
grid minor
datetick('x',15,'Keeplimits','keepticks')
xlabel('Time [hh:mm]')
set(gca,'fontsize',12)
set(ax(2),'fontsize',12)
set(ax(1),'xlim',[datenum('18 May 2017 17:30:00') datenum('19 May 2017, 10:45:05')])
set(ax,'xlim',[datenum('18 May 2017 17:30:00') datenum('19 May 2017, 10:45:05')])

subplot(3,1,3)
plot(CTD(:,7),CTD(:,3),'k.-')
axis ij 
set(gca,'xlim',[datenum('18 May 2017 17:30:00') datenum('19 May 2017, 10:45:05')],'ylim',[0 3.2])
grid on 
grid minor
datetick('x',15,'Keeplimits','keepticks')
xlabel('Time [hh:mm]')
set(gca,'fontsize',12)
ylabel('Depth [m]')

fig=figure(2)
set(fig,'PaperPositionMode','auto')

print -f -dpng /Users/Lena/Documents/BottomDrifter/05_18_2017_Divetest/CTD_Data2