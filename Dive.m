clear all
close all
clc

load DPT_5_18
ff=find(DPTPlus==9999);
DPTPlus(ff)=NaN;

ff=find(DPT==9999);
DPT(ff)=NaN;


figure(1)
clf
bot=DPTPlus(:,3)/10;
time=DPTPlus(:,1);


axis ij

hold on;
dd=plot(DPTPlus(:,1),DPTPlus(:,4)/100,'-b');
ax=axis;
td=plot([ax(1) ax(2)],[4 4],'r')
dob=plot(DPTPlus(:,1),(DPTPlus(:,3)/10)-2,'--r')

yb=[bot;8;8;bot(1)];
xb=[time;time(end);time(1);time(1)];
% ff=fill(xb,yb,[.7 .7 .7])
ff=plot(DPTPlus(:,1),bot,'k')


grid on 
set(gca,'Xlim',[DPTPlus(1,1) DPTPlus(end,1)])
legend([dd,td,dob,ff],'Drifter Depth','Bottom Clearance','Target Depth','Bottom')
ylabel('Depth [m]')
datetick('x',15,'Keeplimits','Keepticks')
xlabel('Time [hh:mm]')

box on 

print -f -dpng /Users/Lena/Documents/BottomDrifter/05_2_2017_Divetest/Dive