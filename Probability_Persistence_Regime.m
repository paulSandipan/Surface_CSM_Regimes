clear;clc;

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

%%
PRS=NaN(w,2);   PWLR=NaN(w,5,2); 
dt=(datetime(2015,3,31):datetime(2022,12,31))';

for k=1:w
    thres=csm(k,:);
    % PRS(k,1) = ProbRegimeTrans(smSMAP(:,k),thres(1));
    % PRS(k,2) = ProbRegimeTrans(smERA5(:,k),thres(2));
    PWLR(k,:,1) = PersistenceWLR(smSMAP(:,k),thres(1),dt);
    PWLR(k,:,2) = PersistenceWLR(smERA5(:,k),thres(2),dt);

end

PRS=1-abs((2*PWLR)-1);

save('PersistenceWLR_ProbRS.mat','PRS',"PWLR")


function PWLR = PersistenceWLR(sm,t,dt)
if ~isnan(t)
    idx=find(isnan(sm)==1); sm(idx)=[]; dt(idx)=[];
    
    mn=month(dt);
    idxDJF=find(mn==12 | mn==1 | mn==2);
    idxMAM=find(mn==3  | mn==4 | mn==5);
    idxJJA=find(mn==6  | mn==7 | mn==8);
    idxSON=find(mn==9  | mn==10| mn==11);

    NumWLR_Ann=length(find(sm<t));
    NumWLR_DJF=length(find(sm(idxDJF)<t));
    NumWLR_MAM=length(find(sm(idxMAM)<t));
    NumWLR_JJA=length(find(sm(idxJJA)<t));
    NumWLR_SON=length(find(sm(idxSON)<t));

    totLenAnn=length(find(isnan(sm)==0));
    totLenDJF=length(find(isnan(sm(idxDJF))==0));
    totLenMAM=length(find(isnan(sm(idxMAM))==0));
    totLenJJA=length(find(isnan(sm(idxJJA))==0));
    totLenSON=length(find(isnan(sm(idxSON))==0));

    PWLR=[NumWLR_Ann/totLenAnn NumWLR_DJF/totLenDJF NumWLR_MAM/totLenMAM NumWLR_JJA/totLenJJA NumWLR_SON/totLenSON];

else
    PWLR(1,1:5)=NaN;
end
end



function PRS = ProbRegimeTrans(sm,t)
if ~isnan(t)
    idx=find(isnan(sm)==1); sm(idx)=[];
    sm1=sm(1:end-1);
    sm2=sm(2:end);
    NumIntersec=length(find(sm1<t & sm2>=t));
    totLen=length(find(isnan(sm)==0));
    PRS=NumIntersec/totLen;
else
    PRS=NaN;
end
end
