clear

% Load the CSM & Model Select datasets
load F:\Projects\PhD_1_CSM_Estimation\Datasets\13_WRR_First_Revision\PersistenceWLR_ProbRS.mat PRS
PRS(:,1,:)=[];       data(:,1:2:8)=PRS(:,:,1);      data(:,2:2:8)=PRS(:,:,2);

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
t=tiledlayout(4,7); tlLoc=[1 4 8 11 15 18 22 25];
yLab=["DEC-JAN-FEB","", "MAR-APR-MAY","","JUN-JUL-AUG","","SEP-OCT-NOV"];
tlt=["Probability of Regime Shift in SAMP-based \theta and \theta*", 
    "Probability of Regime Shift ERA5-based \theta and \theta*"];
% Set the X & Y & Z limits and ticks
xLim=[-180 180];  xDiff=20;    yLim=[-60 60];  yDiff=20;
addpath F:\Projects\Colorpmaps\ColorBrewer_v2\cbrewer2\
cMapNames={'PuBu','PuBu','YlOrRd','YlOrBr','BuGn','BuGn','PuRd','PuRd'};
tlIdx={'(a)','(b)','(d)','(e)','(g)','(h)','(j)','(k)'};

%  Distribution Map
for i=1:8
    ax=nexttile(tlLoc(i),[1,3]); axesm mercator
    mapshow(landPoly,'FaceColor',ones(1,3)*0.9,'EdgeColor','#737373'); hold on
    m=pcolor(x,y,matPlot(:,:,i)');   m.EdgeAlpha=0;
    cMap=cbrewer2(cMapNames{4});
    set(ax,'TickDir','out','Color',ones(1,3)*0.98,'FontSize',14,'Box','off', ...
        'XLim',xLim,'YLim',yLim,'XTickLabel','','YTickLabel','', ...
        'TickLength',[0 0],'XTick',xLim(1):xDiff:xLim(2), ...
        'YTick',yLim(1):yDiff:yLim(2),'GridColor',[99,99,99]/1000, ...
        'GridAlpha',0.5,'CLim',[0 1],'Layer','bottom', ...
        'Colormap',cMap,'GridLineStyle',':')
    if rem(i,2)~=0; ylabel(yLab(i),'FontSize',15,'FontWeight','normal'); end
    if i<=2; title(tlt(i),'FontSize',15,'FontWeight','normal'); end
    grid on
    xline(xLim(2)); yline(yLim(2))
    text(-170,52,tlIdx{i},'FontSize',15,'HorizontalAlignment','center')
end

% cb=colorbar;
% cb.Ticks=0:0.1:1;
% cb.Location='southoutside';
% cb.Label.String='Probability of Regime Shift (P_R_S)';
% cb.TickDirection='out';
% cb.FontSize=14;

t.Padding='compact'; t.TileSpacing='tight';

tlLoc=7:7:28;  tlNum={'(c)','(f)','(i)','(l)'};
col=1; cols={'#64d413','#ff6929'}; txt={'GB','NH','SH'}; txtLoc=1.5:2:6;
load F:\Projects\18_Multi_Reanlayis_dT_Application\Data\Grid_System_Files\Valid_SMAP_Pixel_Loc.mat SMAP_XY_Valid
lat=SMAP_XY_Valid(2,:)'; nhIdx=find(lat<0); shIdx=find(lat>=0);
for i=1:length(tlLoc)
    nexttile(tlLoc(i)); hold on
    d=[data(:,col:col+1) data(:,col:col+1) data(:,col:col+1)]; 
    col=col+2;
    d(nhIdx,3:4)=NaN; d(shIdx,5:6)= NaN;
    
    
    for k=1:2
        boxData=NaN(size(d));        boxData(:,k:2:6)=d(:,k:2:6); 
        boxchart(boxData,'MarkerStyle','none','BoxFaceColor',cols{k}, ...
            'WhiskerLineColor','#dbdbdb','LineWidth',1, 'WhiskerLineStyle', ...
            '--','Notch','on')
    end

    set(gca,'YLim',[-0.15 1.02],'FontSize',12,'TickDir','out', ...
        'TickLength',[0.02 0.02],'YTick',0:0.2:1,'XTick','')

    area([0.5 6.5],[-0.15 -0.15],-0.02,"FaceColor",'#f0f0f0','EdgeColor','none')
    yline([-0.15 -0.02 1.02]); xline(2.5:2:6.5)
    for j=1:length(txt)
        text(txtLoc(j),-0.075,txt{j},'FontSize',12,'FontWeight','normal','HorizontalAlignment','center')
    end
    text(1,0.95,tlNum{i},'FontSize',12,'FontWeight','normal','HorizontalAlignment','center')
    
    if i==1
    text(6.4,0.95,'SMAP','FontSize',12,'FontWeight','bold','HorizontalAlignment','right','Color',cols{1})
    text(6.4,0.83,'ERA5','FontSize',12,'FontWeight','bold','HorizontalAlignment','right','Color',cols{2})
    end

end


%%
% col=1;
% for i=1:4
%     p(i,1)=ranksum(data(:,col),data(:,col+1)); col=col+2;
% end



