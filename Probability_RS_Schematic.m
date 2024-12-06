clear;clc

pWLR=linspace(0,1,101);     pWLR=(pWLR(1:end-1)+pWLR(2:end))/2;
pELR=linspace(0,1,101);     pELR=(pELR(1:end-1)+pELR(2:end))/2;

for i=1:length(pWLR)
    pRs(1:100,i)=1-abs(pWLR(i)-pELR);
end

clf
surf(pWLR,pELR,pRs,'EdgeColor','none')

set(gca,'XTick',0:0.2:1,'YTick',0:0.2:1,'ZTick',0:0.2:1,'FontSize',14)
pbaspect([1 1 1])
xlabel('\phi_W_L_R'); ylabel('\phi_E_L_R'); zlabel('P_R_S')

% addpath F:\Projects\Colorpmaps\ColorBrewer_v2\cbrewer2\
% cMap=(cbrewer2('RdBu'));
% colormap(cMap(25:end-25,:))
% clim([0 1]); 
% cb=colorbar;
% cb.Ticks=[0 0.5 1]; 
cb.Label.String='P_R_S';
% cb.TickLabels={'Persistent ELR','Similar Persistent of ELR & WLR','Persistent WLR'};
