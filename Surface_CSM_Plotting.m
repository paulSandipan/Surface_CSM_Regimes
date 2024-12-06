clear

% Load the CSM & Model Select datasets
load E:\1_Critical_SM\Codes\Surface_First_Revision\Surface_CSM_Flag.mat
flag(flag==0)=NaN;
csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.6)=NaN;
data=csm;

% Load the grid system files
load F:\Projects\18_Multi_Reanlayis_dT_Application\Data\Final_Processed_Variables\SMAP_36km_Grid_System.mat
x=X(:,1); y=Y(1,:);
load F:\Projects\18_Multi_Reanlayis_dT_Application\Data\Grid_System_Files\Valid_SMAP_Pixel_Loc.mat valid_ind
dummyVar=NaN(length(x)*length(y),size(data,2));
dummyVar(valid_ind,:)=data;

% Convert in the regular grid system
matPlot=NaN(length(x),length(y),size(data,2));
row=length(x); col=length(y);
for j=1:size(matPlot,3)
    colIdx=1;
    for k=1:row
        matPlot(k,:,j)=[dummyVar(colIdx:colIdx+col-1,j)];
        colIdx=colIdx+col;
    end
end

clearvars -except matPlot data x y

% Load the land area shapefile
landPoly = shaperead('F:\Projects\15_Multimethod_CSM_Estimation\Datasets\Land_Area.shp');

%% Start Plotting CSM
clf; t=tiledlayout(3,7); tlIdx=[1 8];
tlt=["a: SMAP-\theta and ERA5-dT based \theta* Estimates"; "b: ERA5-\theta and GLDAS-dT based \theta* Estimates"];

% Set the X & Y & Z limits and ticks
xLim=[-180 180];  xDiff=20;    yLim=[-60 60];  yDiff=20;

% Define the the tilte and Colorbar lebel
cbLvl={'\theta* (m^3 m^-^3)';'\theta* (m^3 m^-^3)';'\theta* (m^3 m^-^3)'};
    
%  Distribution Map of CSM
for i=1:2
    ax=nexttile(tlIdx(i),[1 3]); axesm mercator
    mapshow(landPoly,'FaceColor',ones(1,3)*0.9,'EdgeColor','#737373'); hold on
    m=pcolor(x,y,matPlot(:,:,i)');   m.EdgeAlpha=0;
    addpath F:\Projects\Colorpmaps\ColorBrewer_v2\cbrewer2\
    cMap=flip(parula);
    set(ax,'TickDir','out','Color',ones(1,3)*0.98,'FontSize',14,'Box','off', ...
        'XLim',xLim,'YLim',yLim,'XTickLabel','','YTickLabel','', ...
        'TickLength',[0 0],'XTick',xLim(1):xDiff:xLim(2), ...
        'YTick',yLim(1):yDiff:yLim(2),'GridColor',[99,99,99]/1000, ...
        'GridAlpha',0.5,'CLim',[0 0.6],'Layer','bottom', ...
        'Colormap',cMap,'GridLineStyle',':')
    title(tlt(i),'FontSize',16,'FontWeight','normal')
    grid on
    xline(xLim(2)); yline(yLim(2))
end

t.Padding='compact';
t.TileSpacing='compact';

% Distribution
cols={'#41b6c4','#756bb1'};
idx=isnan(data(:,1)) | isnan(data(:,2)); 
data(idx,:)=NaN;
for i=1:2
    % Define the inset location
    if i==1; ax=axes('Position',[0.155 0.718 0.095 0.095]);
    elseif i==2;ax=axes('Position',[0.155 0.402 0.095 0.095]);
    end

    a=data(:,i);  a(a==-9999)=NaN;    a(a==0)=NaN;    a(a>=0.6)=NaN;
    [f,xi]=ksdensity(a,"Function","pdf",'Support','positive','Bandwidth',0.1);
    f=f/max(f);
    area(xi,f,'FaceColor',cols{i},'EdgeColor',cols{i},'LineWidth',2,'FaceAlpha',0.3)
    set(gca,'XLim',[0 0.6],'YLim',[0 1.05],'Box','off','FontSize',12,'TickLength',[0.025 0.025])
    xline(0.6); yline(1.05)
end


%% Latitudinal Average Plot
nexttile(4,[2,1])
cols={'#64d413','#ff6929','#139fff'};
for i=1:2
    clear d
    d(:,:)=matPlot(:,:,i);  d(d==0)=NaN;   d(d>=0.6)=NaN;
    clear LatCritSD LatCritAvg
    LatCritAvg=mean(d,1,'omitnan');
    LatCritSD=std(d,1,'omitnan');
    addpath E:\MATLAB_External_Function_Repository\Area_Bound_Plot\
    [hl,hb]=boundedline(LatCritAvg',y',LatCritSD','alpha','nan', 'gap','orientation', 'horiz');
    hb.FaceColor=cols{i};
    hl.Color=cols{i};
    hl.LineWidth=1.35;
    hold on
end
xTik(1:2:7)=string(0:0.2:0.6); xTik(2:2:6)=repmat("",3,1);
cd E:\1_Critical_SM\Codes\; [~,y_tik]=xyTick_Creation(xLim,yLim,xDiff,10);
set(gca,'GridLineStyle','--','YLim',yLim,'XLim',[0 0.6],'YTick',-60:10:60, ...
    'XTick',0:0.1:0.6,'TickDir','in','FontSize',14,'YTickLabel',y_tik, ...
    'XTickLabel',xTik,'XTickLabelRotation',0)
xlabel('\theta* (m^3 m^-^3)','FontSize',14,'FontWeight','normal')
title('c: Zonal \theta* Behaviour','FontSize',16,'FontWeight','normal')
xline(0.6,'k'); yline(yLim(2),'k'); 
%pbaspect([0.8 1.75 1])
grid on

text(0.05,-56,'\theta*_S_M_A_P','Color',cols{1},'FontSize',14)
text(0.28,-56,'\theta*_E_R_A_5','Color',cols{2},'FontSize',14)






