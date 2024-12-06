clear; clc

load E:\1_Critical_SM\Datasets\LatLon_Files\Valid_SMAP_Pixel_Loc.mat SMAP_XY_Valid
y=SMAP_XY_Valid(2,:)';

load E:\1_Critical_SM\Codes\Surface_First_Revision\Surface_CSM_Flag.mat
flag(flag==0)=NaN;
csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.6)=NaN; 

clearvars -except csm p95 p5

%% Plotting
clc
t=tiledlayout(2,3);

nexttile(1)
x=csm(:,1); y=csm(:,2);
idx=isnan(x) | isnan(y);
x(idx)=[]; y(idx)=[];

addpath F:\Projects\2_Perfm_Analysis_Rain_Data\B_Codes\FACS\
scatter(x,y,5,x-y,"filled",'MarkerEdgeColor','none','MarkerFaceAlpha',0.6)

set(gca,'TickDir','out','FontSize',14,'Box','off','XLim',[0 0.6], ...
    'YLim',[0 0.6],'XTick',0:0.1:0.6,'YTick',0:0.1:0.6)
xline(0.6); yline(0.6)
pbaspect([1 1 1])

addpath F:\Projects\Colorpmaps\ColorBrewer_v2\cbrewer2\
colormap(flip(cbrewer2('RdBu')))

ols=fitlm(x,y); beta=ols.Coefficients.Estimate;
xHat=linspace(min(x),max(x),100);
yHat=beta(1)+beta(2)*xHat;

hold on; 
plot(xHat,yHat,'LineWidth',1.5,'Color','#b746ff','LineStyle','--')
txt=['\theta*_E_R_A_5 = ',num2str(round(beta(1),2)),' + ',num2str(round(beta(2),2)) ,' \times \theta*_S_M_A_P'];
text(0.02, 0.56,txt,'Color','#b746ff','FontSize',14)

r=corr(x,y,"rows",'complete');
txt=['Corr. Coeff = ', num2str(round(r,2)),' (\alpha = 0.05)'];
text(0.02, 0.5,txt,'Color','k','FontSize',14)

plot([0 1],[0 1],'LineStyle','--','LineWidth',0.5,'Color','#525252')

xlabel('\theta*_E_R_A_5 (m^3 m^-^3)')
ylabel('\theta*_S_M_A_P (m^3 m^-^3)')

clim([-0.4 0.4])
cb=colorbar; cb.Ticks=-0.4:0.1:0.4;
cb.FontSize=14; cb.Label.String='\theta*_S_M_A_P - \theta*_E_R_A_5';

text(-0.135,0.6,'(a)','FontSize',18)

nexttile; hold on
yyaxis left
data=NaN(size(x,1),3); data(:,1)=x;
boxchart(data,'BoxFaceColor','#139fff','MarkerStyle','none','WhiskerLineStyle','--','WhiskerLineColor','#525252','Notch','on')
data=NaN(size(x,1),3); data(:,2)=y;
boxchart(data,'BoxFaceColor','#edb120','MarkerStyle','none','WhiskerLineStyle','--','WhiskerLineColor','#525252','Notch','on')
set(gca,'TickDir','out','FontSize',14,'Box','off', ...
    'YLim',[0 0.6],'YTick',0:0.1:0.6,'YColor','k')
yline(0.6)
ylabel('\theta* (m^3 m^-^3)')
text(0.5,0.56,'\theta*_S_M_A_P - \theta*_E_R_A_5','FontSize',14,'Color','#64d413','FontWeight','bold')
text(0.5,0.505,'\theta*_E_R_A_5','FontSize',14,'Color','#edb120','FontWeight','bold')
text(0.5,0.455,'\theta*_S_M_A_P','FontSize',14,'Color','#139fff','FontWeight','bold')
text(-1,0.6,'(b)','FontSize',18)

yyaxis right
data=NaN(size(x,1),3); data(:,3)=x-y;
boxchart(data,'BoxFaceColor','#64d413','MarkerStyle','none','WhiskerLineStyle','--','WhiskerLineColor','#525252','Notch','on')
ylim([-0.3 0.3]); set(gca,'YColor','k','FontSize',14,'YTick',-0.3:0.1:0.3)
ylabel('\theta*_S_M_A_P - \theta*_E_R_A_5')
xticklabels('')

pbaspect([0.8 1 1])

%%
boxName={'India','WestUSA','EastBrazil','Mediterranean','Sahel','EastAfrica',...
    'SouthAfrica','NorthAustrial'};
load E:\1_Critical_SM\Datasets\LatLon_Files\Valid_SMAP_Pixel_Loc.mat SMAP_XY_Valid
x=SMAP_XY_Valid(1,:)'; y=SMAP_XY_Valid(2,:)';
path='E:\Critical_SM\BoxSelectionsV2\';
addpath F:\Projects\15_Multimethod_CSM_Estimation\Codes\Figure_Making_Global_Scale\  
boxData=[];
for i=1:length(boxName)
roi=[path, boxName{i} '.shp'];
[roi_data,roi_grid_loc] = FindDataInPolygonV2(x,y,csm',roi);
boxData(1:length(roi_grid_loc),end+1:end+2)=roi_data';
end
boxData(boxData==0)=NaN;

t=tiledlayout(3,4);
nexttile(1,[1,2])
cols={'#139fff','#edb120'};%{'#b746ff','#4dbeee','#64d413'}; %{'#ff6929','#b746ff','#4dbeee','#64d413'};
for k=1:2
    clear data
    data=boxData;
    if k==1; data(:,2:2:end)=NaN; end
    if k==2; data(:,1:2:end)=NaN; end
    boxchart(data,'MarkerStyle','none','BoxWidth',0.4,'BoxFaceColor', ...
        cols{k},'WhiskerLineColor','#737373','WhiskerLineStyle','--','Notch','on')
    hold on
    if k==1; for i=1:2:16; dp(i,1)=length(find(isnan(data(:,i))==0)); end; end
    if k==2; for i=2:2:16; dp(i,1)=length(find(isnan(data(:,i))==0)); end; end
end

set(gca,'FontSize',14,'FontWeight','normal','YLim',[-0.07 0.6], ...
     'YTick',0:0.1:0.6,'TickDir','out','XTick','','XTickLabel','', ...
     'TickLength',[0.0075 0.0075])
area([0.5 16.5],[-0.1 -0.1],0,'FaceColor','#f0f0f0','EdgeColor','none')
xline(2.5:2:16.5);  yline([-0.07 0 0.6])
txt={'India','W. USA','E. Brazil','Mediterr.','Sahel','E. Africa',...
    'S. Africa','Australia'};
txtloc=1.5:2:16.5;
for i=1:length(txtloc)
    text(txtloc(i),-0.035,txt{i},'FontSize',14,'FontWeight','normal','HorizontalAlignment','center')
end

for i=1:16
    text(i,0.57,num2str(dp(i)),'FontSize',10,'FontWeight','normal','HorizontalAlignment','center')
end
ylabel('\theta* (m^3 m^-^3)')

t.Padding='compact'; t.TileSpacing='compact';



binCSM=NaN(length(csm),10);
access=csm; access(access(:,1)>0.1,:)=NaN; binCSM(:,1:2)=access;
access=csm; access(access(:,1)<=0.1 | access(:,1)>0.2,:)=NaN; binCSM(:,3:4)=access;
access=csm; access(access(:,1)<=0.2 | access(:,1) >0.3,:)=NaN; binCSM(:,5:6)=access;
access=csm; access(access(:,1)<=0.3 | access(:,1) >0.4,:)=NaN; binCSM(:,7:8)=access;
access=csm; access(access(:,1)<=0.4 | access(:,1) >0.5,:)=NaN; binCSM(:,9:10)=access;

nexttile
data=NaN(size(binCSM)); data(:,1:2:end)=binCSM(:,1:2:end);
boxchart(data,'BoxFaceColor','#139fff','MarkerStyle','none','WhiskerLineStyle','--','WhiskerLineColor','#525252')
hold on
data=NaN(size(binCSM)); data(:,2:2:end)=binCSM(:,2:2:end);
boxchart(data,'BoxFaceColor','#b746ff','MarkerStyle','none','WhiskerLineStyle','--','WhiskerLineColor','#525252')

%%
r=1;
for i=1:2:size(boxData,2)
    p(r,1)=ranksum(boxData(:,i),boxData(:,i+1));
    r=r+1;
end







