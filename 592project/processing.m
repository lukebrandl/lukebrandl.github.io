%% author: Luke Brandl
%% project: EECS 592 Replication Project
%% file description: This file is a matlab script that applies multivariate linear regression to the data
%% Unfortunately the data I used for this experiment is not included due to my agreement with Michal Kosinsky. 
%% This is however the code I used for the experiement expalained in the pdf in this directory.


load labels.mat
load rawdata.mat

countmatrix=isnan(pruneddata);
counts=374965-sum(countmatrix); %hardcoded
friends = nanmean(pruneddata(:,7));
density = nanmean(pruneddata(:,6));
groups = nanmean(pruneddata(:,4));
likes = nanmean(pruneddata(:,1));
photos = NaN; %Not used here
statuses = nanmean(pruneddata(:,2));
tags = nanmean(pruneddata(:,5));
events = nanmean(pruneddata(:,3));
months = nanmean(pruneddata(:,8));

aves = nanmean(pruneddata(:,1:7));

% feature regularization
data = pruneddata(:,1:7);
for i=1:374965
    for j=1:7
        if countmatrix(i,j)
           data(i,j)=aves(j); 
        end
        
    end
    data(i,1:5)=data(i,1:5)/pruneddata(i,8);
end

extdata = [pruneddata(:,1:7),ones(374965,1)];
esums= 6-sum(countmatrix(:,[1:2,4:7]),2);
extdata = zeros(sum(esums==6),7);
extlabels = zeros(sum(esums==6),1);
ind=1;
for i=1:374965
    if(esums(i)==6)
        extdata(ind,:)=[pruneddata(i,[1:2,4:7]),1];
        extdata(ind,1:4)=log(extdata(ind,1:4)/pruneddata(i,8));
        extdata(ind,5:6)=log(extdata(ind,5:6));
        extlabels(ind,1)=labels(i,3);
        ind=ind+1;
    end
end
[beta, Sigma,e,covar,llog]=mvregress(extdata,extlabels);
pred = extdata*beta;
[r,p]=corr(pred, extlabels);


% K-fold cross validation
indices = crossvalind('Kfold', 17135,10);
rcross=zeros(10,1);
for i=1:10
    test = (indices==i);
    train=~test;
    [beta, Sigma,e,covar,llog]=mvregress(extdata(train,:),extlabels(train,:));
    pred = extdata(test,:)*beta;
    rcross(i,1)=corr(extlabels(test,:),pred);
end
error = mean(rcross);