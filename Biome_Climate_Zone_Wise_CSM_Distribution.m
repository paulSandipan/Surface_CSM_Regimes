%% Process confounding variable data
clear; clc
confVar = confoundingDataClassify;
load E:\1_Critical_SM\Codes\Surface_First_Revision\Surface_CSM_Flag.mat
flag(flag==0)=NaN;
csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.6)=NaN;

boxData1 = DependentVarBoxDataProcess (confVar(:,1),csm);
boxData2 = DependentVarBoxDataProcess (confVar(:,2),csm);
boxData=[boxData1 boxData2];
clearvars -except boxData csm

%% Plotting
t=tiledlayout(3,4); t.Padding='compact'; 
nexttile(1,[1 2])
fCols={'#139fff','#b746ff'};
for k=1:2
    kData=NaN(size(boxData));   kData(:,k:2:end)=boxData(:,k:2:end);
    boxchart(kData,'BoxFaceColor',fCols{k},'MarkerStyle','none','WhiskerLineColor','#dbdbdb','WhiskerLineStyle','--')
    hold on
end

yLim=[-0.1 0.6]; yDiff=0.1; yTikStrt=0; yLab='\theta* (m^3 m^-^3)';
labBandLim=[0.5 24.5;-0.1 -0.1]; xLnStrt=2.5; xLnIntv=2;  xLoc=1.5:2:24; xLabYcord = -0.05;
xTikLab={'EBF','DBF','MF','OSH','SAV','GRA','CRO','TROP','DRY','STROP','TEMP','CONT'};

% Plot asthetics settings
set(gca,'TickDir','out','TickLength',[0.005 0.005],'FontSize',14, ...
    'XTickLabel','','YLim',yLim,'YTick',yTikStrt:yDiff:yLim(2),'XTick','')
ylabel(yLab,'FontSize',14,'FontWeight','normal')
area(labBandLim(1,:),labBandLim(2,:),yTikStrt,'FaceColor','#f0f0f0','EdgeColor','none')
xline([labBandLim(1,2), xLnStrt:2:labBandLim(1,2)]); 
yline([yLim(2) yTikStrt yLim(1)]); 
for i=1:length(xLoc)
text(xLoc(i),xLabYcord,xTikLab{i},'FontSize',14,'FontWeight','normal','HorizontalAlignment','center')
end
