clear; clc

load F:\Projects\PhD_1_CSM_Estimation\Datasets\13_WRR_First_Revision\PersistenceWLR_ProbRS.mat
load F:\Projects\PhD_1_CSM_Estimation\Datasets\13_WRR_First_Revision\Surface_CSM_Flag.mat flag

PWLR(:,1,:)=[]; PRS(:,1,:)=[];
PWLR(:,:,1)=PWLR(:,:,1).*flag(:,1); PWLR(:,:,2)=PWLR(:,:,2).*flag(:,2);
PRS(:,:,1)=PRS(:,:,1).*flag(:,1); PRS(:,:,2)=PRS(:,:,2).*flag(:,2);

prsVI=NaN(size(PRS,1),size(PRS,3));
pwlrVI=NaN(size(PRS,1),size(PRS,3));

for j=1:size(PRS,1)
    for k=1:size(PRS,3)
        prsVI(j,k) =(sum(abs(PRS(j,:,k)-mean(PRS(j,:,k),'omitmissing'))/mean(PRS(j,:,k),'omitmissing'))/4)*100;
        pwlrVI(j,k)=(sum(abs(PWLR(j,:,k)-mean(PWLR(j,:,k),'omitmissing'))/mean(PWLR(j,:,k),'omitmissing'))/4)*100;
    end
end

clearvars -except pwlrVI prsVI

%%

cols={'r','b','#ff6929','#139fff','#b746ff','#64d413',};
t=tiledlayout(5,6);  tlLoc=[1 13]; 
xLab={'Aridity Classes      Biome Regions      Transitional Regions'};
xTikLab={'HA','A','SA','DSH','SH','H','EBF','DBF','MF','OSH','SAV','GRA','CRO','IND','WUSA','EBRZ','MEDT','SHL','EAFR','SAFR','AUST'};
tltTxt={'Persistence of Water-Limited Regime (\phi_W_L_R)','Probability of Regime Shifting (P_R_S)'};
figIdx={'(a)','(b)','(c)';'(d)','(e)','(f)'};
figLoc=[1 13 27]+0.3;

for i=1:2

if i==1; data=pwlrVI; else; data=prsVI; end

addpath F:\Projects\18_Multi_Reanlayis_dT_Application\Codes\Figure_Making\
confVar  = confoundingDataClassify;
boxData1 = DependentVarBoxDataProcess (confVar(:,3),data);
boxData2 = DependentVarBoxDataProcess (confVar(:,1),data);
boxData3 = RegionWiseVarData(data);
boxData3(end+1:length(boxData2),:)=NaN;

boxData=[boxData1 boxData2 boxData3];


nexttile(tlLoc(i),[2 4])
    
for k=1:2
d=NaN(size(boxData)); d(:,k:2:end)=boxData(:,k:2:end);
boxchart(d,'MarkerStyle','none','BoxFaceColor', ...
    cols{k},'WhiskerLineColor','#969696','WhiskerLineStyle','--','Notch','on')
hold on
end

yLim=[-25 150]; yDiff=30; yTikStrt=-5; 
yLab='Variability Index (%)';
labBandLim=[0.5 42.5;-30 -30]; xLnStrt=2.5; xLnIntv=2;  xLoc=1.5:2:42; xLabYcord = -12.5;

% Plot asthetics settings
set(gca,'TickDir','out','TickLength',[0.005 0.005],'FontSize',14, ...
    'XTickLabel','','YLim',yLim,'YTick',yTikStrt+5:yDiff:yLim(2),'XTick','')
ylabel(yLab,'FontSize',16,'FontWeight','normal')
area(labBandLim(1,:),labBandLim(2,:),yTikStrt,'FaceColor','#f0f0f0','EdgeColor','none')
xline([labBandLim(1,2), xLnStrt:2:labBandLim(1,2)]);
yline([yLim(2) yTikStrt yLim(1)]);
for j=1:length(xTikLab)
    text(xLoc(j),xLabYcord,xTikLab{j},'FontSize',12,'FontWeight','normal','HorizontalAlignment','center')
end
title(tltTxt{i},'FontSize',16,'FontWeight','normal')
if i==2; xlabel(xLab); end

for k=1:3
    text(figLoc(k),140,figIdx{i,k},'FontSize',16,'FontWeight','normal','HorizontalAlignment','center')
end

end


















