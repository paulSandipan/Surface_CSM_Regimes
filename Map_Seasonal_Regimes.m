clear

load('Seasonal_Regimes_D.mat','regimeInfo')
data=regimeInfo;

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

%%
t=tiledlayout(4,2);
yLab=["DEC-JAN-FEB","", "MAR-APR-MAY","","JUN-JUL-AUG","","SEP-OCT-NOV"];
tlt=["SAMP-based \theta and \theta*", "ERA5-based \theta and \theta*"];
% Set the X & Y & Z limits and ticks
xLim=[-180 180];  xDiff=20;    yLim=[-60 60];  yDiff=20;
cMap=[0.93,0.69,0.13;0.39,0.83,0.07;0.07,0.62,1]; 

%  Distribution Map
for i=1:8
    ax=nexttile(i); axesm mercator
    mapshow(landPoly,'FaceColor',ones(1,3)*0.9,'EdgeColor','#737373'); hold on
    m=pcolor(x,y,matPlot(:,:,i)');   m.EdgeAlpha=0;

    set(ax,'TickDir','out','Color',ones(1,3)*0.98,'FontSize',14,'Box','off', ...
        'XLim',xLim,'YLim',yLim,'XTickLabel','','YTickLabel','', ...
        'TickLength',[0 0],'XTick',xLim(1):xDiff:xLim(2), ...
        'YTick',yLim(1):yDiff:yLim(2),'GridColor',[99,99,99]/1000, ...
        'GridAlpha',0.5,'CLim',[1 3],'Layer','bottom', ...
        'Colormap',cMap,'GridLineStyle',':')
    if rem(i,2)~=0; ylabel(yLab(i),'FontSize',16,'FontWeight','normal'); end
    if i<=2; title(tlt(i),'FontSize',16,'FontWeight','normal'); end
    grid on
    xline(xLim(2)); yline(yLim(2))
end

cb=colorbar;

t.Padding='compact';
t.TileSpacing='compact';

tlIdx={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
for i=1:length(tlIdx)
    nexttile(i)
    text(-170,52,tlIdx{i},'FontSize',18,'HorizontalAlignment','center')
end




