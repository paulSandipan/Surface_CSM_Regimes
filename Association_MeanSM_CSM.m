clear; clc
load E:\1_Critical_SM\Datasets\LatLon_Files\Valid_SMAP_Pixel_Loc.mat SMAP_XY_Valid
y=SMAP_XY_Valid(2,:)';

load E:\1_Critical_SM\Codes\Surface_First_Revision\Surface_CSM_Flag.mat
flag(flag==0)=NaN;
csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.6)=NaN;

load E:\1_Critical_SM\Datasets\SM_Statistics_Perf_Measure\Soil_Moisture_Statistics_GridForm.mat avg
avg(:,3:4)=[];

%% Plotting
t=tiledlayout(2,3);

for i=1:2
nexttile(i); x=csm(:,i); y=avg(:,i);
idx=isnan(x) | isnan(y);    x(idx)=[]; y(idx)=[];
addpath F:\Projects\2_Perfm_Analysis_Rain_Data\B_Codes\FACS\
dscatterV2(x,y);

set(gca,'TickDir','out','FontSize',14,'Box','off','XLim',[0 0.6], ...
    'YLim',[0 0.6],'XTick',0:0.1:0.6,'YTick',0:0.1:0.6)
xline(0.6); yline(0.6)
pbaspect([1 1 1])

addpath F:\Projects\Colorpmaps\ColorBrewer_v2\cbrewer2\
colormap(flip(cbrewer2('Spectral')))

ols=fitlm(x,y); beta=ols.Coefficients.Estimate;
xHat=linspace(min(x),max(x),100);
yHat=beta(1)+beta(2)*xHat;

hold on; 
plot(xHat,yHat,'LineWidth',1.5,'Color','r','LineStyle','--')
if i==1; txt=['\theta_S_M_A_P = ',num2str(round(beta(1),2)),' + ',num2str(round(beta(2),2)) ,' \times \theta*_S_M_A_P'];
else; txt=['\theta_E_R_A_5 = ',num2str(round(beta(1),2)),' + ',num2str(round(beta(2),2)) ,' \times \theta*_E_R_A_5'];
end
text(0.02, 0.56,txt,'Color','r','FontSize',14)

r=corr(x,y,"rows",'complete');
txt=['Corr. Coeff = ', num2str(round(r,2)),' (\alpha = 0.05)'];
text(0.02, 0.51,txt,'Color','k','FontSize',14)

plot([0 1],[0 1],'LineStyle','--','LineWidth',0.5,'Color','#525252')

if i==1; ylabel('\theta_S_M_A_P (m^3 m^-^3)'); xlabel('\theta*_S_M_A_P (m^3 m^-^3)');
else;  ylabel('\theta_E_R_A_5 (m^3 m^-^3)'); xlabel('\theta*_E_R_A_5 (m^3 m^-^3)'); end

text(-0.135,0.6,'(a)','FontSize',18)

end


binCSM=NaN(length(csm),10);
access=csm-avg; access(avg>0.1)=NaN;            binCSM(:,1:2)=access;
access=csm-avg; access(avg<=0.1 | avg>0.2)=NaN; binCSM(:,3:4)=access;
access=csm-avg; access(avg<=0.2 | avg>0.3)=NaN; binCSM(:,5:6)=access;
access=csm-avg; access(avg<=0.3 | avg>0.4)=NaN; binCSM(:,7:8)=access;
access=csm-avg; access(avg<=0.4 | avg>0.5)=NaN; binCSM(:,9:10)=access;

nexttile(3)
data=NaN(size(binCSM)); data(:,1:2:end)=binCSM(:,1:2:end);
boxchart(data,'BoxFaceColor','#64d413','MarkerStyle','none','WhiskerLineStyle','--','WhiskerLineColor','#525252')
hold on
data=NaN(size(binCSM)); data(:,2:2:end)=binCSM(:,2:2:end);
boxchart(data,'BoxFaceColor','#ff6929','MarkerStyle','none','WhiskerLineStyle','--','WhiskerLineColor','#525252')

set(gca,'TickDir','out','FontSize',14,'Box','off', ...
    'YLim',[-0.2 0.2],'XTick','','YTick',-0.2:0.1:0.2)
grid on
xline(2.5:2:10.5);yline(0.2)

text(0.7,-0.13 ,'\theta*_S_M_A_P - \theta_S_M_A_P','FontSize',14,'FontWeight','bold','Color','#64d413')
text(0.7,-0.17,'\theta*_E_R_A_5 - \theta_E_R_A_5','FontSize',14,'FontWeight','bold','Color','#ff6929')
ylabel('\theta* - \theta (m^3 m^-^3)')

binStr={'0 - 0.1','0.1 - 0.2','0.2 - 0.3','0.3 - 0.4','0.4 - 0.5'}; loc=1.5;
for i=1:length(binStr)
    text(loc,-0.22,binStr{i},"FontSize",14,'HorizontalAlignment','center'); loc=loc+2;
end
text(5.5,-0.25,'Mean Soil Moisture Bins (m^3 m^-^3)','FontSize',14,'HorizontalAlignment','center')




