clear
% Load the CSM & Model Select datasets
load E:\1_Critical_SM\Codes\WRR_Major_Revision\PersistenceWLR_ProbRS.mat PRS
PRS(:,1,:)=[];       data(:,1:2:8)=PRS(:,:,1);      data(:,2:2:8)=PRS(:,:,2);

% Load the CSM & Model Select datasets
load E:\1_Critical_SM\Codes\Surface_First_Revision\Surface_CSM_Flag.mat
flag(flag==0)=NaN; csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.55)=NaN;

idx=isnan(csm(:,1)) | isnan(csm(:,2));
data(idx==1,:)=NaN;

t=tiledlayout(4,4);t.Padding='compact'; t.TileSpacing='compact';

cols={'#64d413','#ff6929'};%{'#b746ff','#4dbeee','#64d413'}; %{'#ff6929','#b746ff','#4dbeee','#64d413'};

nexttile
boxData=NaN(size(data)); boxData(:,1:2:8)=data(:,1:2:8);
boxchart(boxData,'MarkerStyle','none','BoxWidth',0.4,'BoxFaceColor', ...
    cols{1},'WhiskerLineColor','#737373','WhiskerLineStyle','--','Notch','on','LineWidth',1.25)
hold on
boxData=NaN(size(data)); boxData(:,2:2:8)=data(:,2:2:8);
boxchart(boxData,'MarkerStyle','none','BoxWidth',0.4,'BoxFaceColor', ...
    cols{2},'WhiskerLineColor','#737373','WhiskerLineStyle','--','Notch','on','LineWidth',1.25)
set(gca,'XColor','none')

