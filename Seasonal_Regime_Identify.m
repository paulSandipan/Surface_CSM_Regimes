clear

load E:\1_Critical_SM\Codes\Surface_First_Revision\Surface_CSM_Flag.mat
flag(flag==0)=NaN;
csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.6)=NaN;

load E:\1_Critical_SM\Datasets\A_SMAP_SM_Grid_Wise_Timeseries\Valid_SMAP_36km_TimeSeries.mat
load E:\1_Critical_SM\Datasets\B_A_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_Mean_SM_L1_Mod.mat
smERA5=sm_valid;  smSMAP=SMAP_SM_Valid;
clearvars -except csm smSMAP smERA5

dt=(datetime(2015,1,1):datetime(2022,12,31))';
a=datetime(2015,3,30);  b=find(dt==a);
smERA5(1:b,:)=[];       dt(1:b,:)=[];
[~,w]=size(smSMAP);

smMask=ones(size(smERA5)); smMask(isnan(smSMAP))=NaN;
smERA5=smERA5.*smMask;

clearvars -except csm smSMAP smERA5 w
dt=(datetime(2015,3,31):datetime(2022,12,31))';

load E:\1_Critical_SM\Codes\WRR_Major_Revision\PersistenceWLR_ProbRS.mat PWLR PRS
PELR=1-PWLR;  PELR(:,1,:)=[]; PWLR(:,1,:)=[]; PRS(:,1,:)=[];

%%
D=NaN(length(csm),4,2);
for k=1:size(PRS,3)
for i=1:size(PRS,1)
    
    if k==1 && ~isnan(csm(i,k));       storeD=ashman_D_comput(smSMAP(:,i),csm(i,k),dt); D(i,:,k)=storeD(2:5);
    elseif k==2 && ~isnan(csm(i,k));   storeD=ashman_D_comput(smERA5(:,i),csm(i,k),dt); D(i,:,k)=storeD(2:5); end
    
    for j=1:size(PRS,2)
        if ~isnan(PRS(i,j,k))
            val=[PWLR(i,j,k) PRS(i,j,k) PELR(i,j,k)];
            maxVal=max(val,[],'omitmissing');
            idx=find(val==maxVal);
            regime(i,j,k)=idx;
        else
            regime(i,j,k)=NaN;
        end
    end
end
end
regimeInfo(:,1:2:8)=regime(:,:,1); regimeInfo(:,2:2:8)=regime(:,:,2);

save('Seasonal_Regimes_D.mat','regimeInfo','D')

% Ashman's D  Calculation
function D = ashman_D_comput(sm,t,dt)
if ~isnan(t)
    idx=find(isnan(sm)==1); sm(idx)=[]; dt(idx)=[];
    
    mn=month(dt);
    idxDJF=find(mn==12 | mn==1 | mn==2);
    idxMAM=find(mn==3  | mn==4 | mn==5);
    idxJJA=find(mn==6  | mn==7 | mn==8);
    idxSON=find(mn==9  | mn==10| mn==11);

    modAnn=[mode(sm<t) mode(sm>=t)];
    modDJF=[mode(sm(idxDJF)<t) mode(sm(idxDJF)>=t)];
    modMAM=[mode(sm(idxMAM)<t) mode(sm(idxMAM)>=t)];
    modJJA=[mode(sm(idxJJA)<t) mode(sm(idxMAM)>=t)];
    modSON=[mode(sm(idxSON)<t) mode(sm(idxMAM)>=t)];

    iqrAnn=[iqr(sm<t) iqr(sm>=t)];
    iqrDJF=[iqr(sm(idxDJF)<t) iqr(sm(idxDJF)>=t)];
    iqrMAM=[iqr(sm(idxMAM)<t) iqr(sm(idxMAM)>=t)];
    iqrJJA=[iqr(sm(idxJJA)<t) iqr(sm(idxMAM)>=t)];
    iqrSON=[iqr(sm(idxSON)<t) iqr(sm(idxMAM)>=t)];
    
    D(1,1)=abs(modAnn(1)-modAnn(2))/(0.5*(iqrAnn(1)+iqrAnn(2)));
    D(2,1)=abs(modDJF(1)-modDJF(2))/(0.5*(iqrDJF(1)+iqrDJF(2)));
    D(3,1)=abs(modMAM(1)-modMAM(2))/(0.5*(iqrMAM(1)+iqrMAM(2)));
    D(4,1)=abs(modJJA(1)-modJJA(2))/(0.5*(iqrJJA(1)+iqrJJA(2)));
    D(5,1)=abs(modSON(1)-modSON(2))/(0.5*(iqrSON(1)+iqrSON(2)));
else
    D(1,1:5)=NaN;
end
end



