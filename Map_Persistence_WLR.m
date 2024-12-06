clear

% Load the CSM & Model Select datasets
load E:\1_Critical_SM\Codes\WRR_Major_Revision\PersistenceWLR_ProbRS.mat PWLR PRS
PWLR(:,2:5,:)=[]; PRS(:,2:5,:)=[];
data=[squeeze(PWLR) squeeze(PRS)];

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

%% Start Plotting Persistence of WLR
clf; t=tiledlayout(3,7); tlIdx=[1 8 4 11];
tlt=["a: Persistence of WLR based on SMAP \theta and \theta* Estimate"; 
    "b: Persistence of WLR based on ERA5 \theta and \theta* Estimate";
    "c: Probability of Regime Shift based on SMAP \theta and \theta* Estimate";
    "d: Probability of Regime Shift based on ERA5 \theta and \theta* Estimate"];

% Set the X & Y & Z limits and ticks
xLim=[-180 180];  xDiff=20;    yLim=[-60 60];  yDiff=20;

% Define the the tilte and Colorbar lebel
cbLvl={'\phi_W_L_R';'\phi_W_L_R'};
    
%  Distribution Map of CSM
for i=1:4
    ax=nexttile(tlIdx(i),[1 3]); axesm mercator
    mapshow(landPoly,'FaceColor',ones(1,3)*0.9,'EdgeColor','#737373'); hold on
    m=pcolor(x,y,matPlot(:,:,i)');   m.EdgeAlpha=0;
    addpath F:\Projects\Colorpmaps\ColorBrewer_v2\cbrewer2\
    if i<=2; cMap=flip(hot); else; cMap=jet; end
    colormap(ax,cMap(35:end-25,:));
    set(ax,'TickDir','out','Color',ones(1,3)*0.98,'FontSize',14,'Box','off', ...
        'XLim',xLim,'YLim',yLim,'XTickLabel','','YTickLabel','', ...
        'TickLength',[0 0],'XTick',xLim(1):xDiff:xLim(2), ...
        'YTick',yLim(1):yDiff:yLim(2),'GridColor',[99,99,99]/1000, ...
        'GridAlpha',0.5,'Layer','bottom','GridLineStyle',':')
    title(tlt(i),'FontSize',16,'FontWeight','normal')
    grid on
    xline(xLim(2)); yline(yLim(2))
    if i<=2; clim([0.5 1]); else; clim([0 1]); end
    cb=colorbar; cb.Location='west';

end

t.Padding='compact';
t.TileSpacing='compact';






