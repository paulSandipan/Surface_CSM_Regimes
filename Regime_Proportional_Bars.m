clear; clc

load('E:\1_Critical_SM\Codes\WRR_Major_Revision\Seasonal_Regimes_D.mat','regimeInfo')
load E:\1_Critical_SM\Datasets\LatLon_Files\Valid_SMAP_Pixel_Loc.mat SMAP_XY_Valid; 
y=SMAP_XY_Valid(2,:)';  nh=ones(length(y),1); nh(y<0)=NaN; sh=ones(length(y),1); sh(y>0)=NaN;
%idx=find(isnan(regimeInfo(:,1)-regimeInfo(:,5))==1); regimeInfo(idx,:)=NaN;
smapRegimes=regimeInfo(:,1:2:end); era5Regimes=regimeInfo(:,2:2:end); 
data=[];
for i=1:4
    data(:,end+1:end+4)=[smapRegimes(:,i).*nh era5Regimes(:,i).*nh smapRegimes(:,i).*sh era5Regimes(:,i).*sh];
end

addpath F:\Projects\18_Multi_Reanlayis_dT_Application\Codes\Figure_Making\
confVar = confoundingDataClassify; confVar(:,1:2)=[];
uqAI=unique(confVar(~isnan(confVar)));


t=tiledlayout(4,6); 
tlIdx=reshape(1:24,[6 4]); tlIdx(5:6,:)=[]; tlIdx=reshape(tlIdx,[1 size(data,2)]);
tltTxt={'Regimes in SMAP \theta','Regimes in ERA5 \theta','Regimes in SMAP \theta','Regimes in ERA5 \theta'};
yLab=["DEC-JAN-FEB","MAR-APR-MAY","JUN-JUL-AUG","SEP-OCT-NOV"]; yLabLoc=[1:4:16 17];

for i=1:size(data,2)
    clear iData
    %iData=ones(length(data),length(uqAI)).*data(:,i);
    for j=1:length(uqAI)
        iData(:,j)=data(:,i);
    end
    for j=1:length(uqAI)
        idx=find(confVar~=uqAI(j));
        iData(idx,j)=NaN;
    end
    clear rgmProp
    for j=1:size(iData,2)
        numWLR=length(find(iData(:,j)==1));
        numTRN=length(find(iData(:,j)==2));
        numELR=length(find(iData(:,j)==3));
        numTot=length(find(isnan(iData(:,j))==0));
        rgmProp(j,1:3)=[numWLR/numTot numTRN/numTot numELR/numTot]*100;
    end
    disp(rgmProp)
    ax=nexttile(tlIdx(i));
    b=bar(rgmProp,'stacked');
    b(1).FaceColor='r'; b(1).FaceAlpha=0.7;
    b(2).FaceColor='k'; b(2).FaceAlpha=0.3;
    b(3).FaceColor='b'; b(3).FaceAlpha=0.7;

    set(gca,'XLim',[0.35 6.65],'YLim',[-5 105],'TickDir','out', ...
        'FontSize',14,'GridLineWidth',1.25,'Box','off','YTick',0:25:100, ...
        'GridColor','#525252')
    xline(6.65); yline(105); yline(0,'w')
    if i>12; xticklabels({'HA','A','SA','DSH','SH','H'}); else; xticklabels(''); end
    if i<=4; title(tltTxt{i},'FontSize',14,'FontWeight','normal'); end
    if i==yLabLoc(1); ylabel(yLab(1)); yLabLoc(1)=[]; yLab(1)=[];;end
    grid on
    pbaspect([0.95 0.8 1])
end
ylabel(t,'Fraaction of Grids (%)','FontSize',18);
lgd=legend({'Energy-Limited Regime','Transitional Regime','Water-Limited Regime','','',''});
lgd.NumColumns=1; lgd.Layout.Tile=tlIdx(end)+1; lgd.FontSize=16; lgd.EdgeColor='none';
t.Padding='compact'; t.TileSpacing='compact';



