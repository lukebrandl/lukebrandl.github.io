%% author: Luke Brandl
%% project: EECS 592 Replication Project
%% file description: This file is a matlab script designed to preprocess the data from the paper "Manifestations of user personality in website choice and behaviour on online social networks" 
%% Unfortunately the data I used for this experiment is not included due to my agreement with Michal Kosinsky. 
%% This is however the code I used for the experiment explained in the pdf in this directory.
%% The methods I used to clean the data are explained most clearly in the same pdf.

fileid=fopen('freq.csv');
% contents are in form userid,n_like,n_status,n_event,n_concentration,n_group,n_work,n_education,n_tags,n_diads
freq = textscan(fileid, '%s %f %f %f %f %f %f %f %f %f', 'Delimiter', ',','EmptyValue',NaN, 'HeaderLines',1);
fclose(fileid);
ids = freq{1};
data = [freq{2},freq{3},freq{4},freq{6},freq{9}];
% 2,3,4,6,9,10 are the features I care about, namely:
% n_like,n_status,n_event,n_group,n_tags,n_diads

fileid=fopen('sna.csv'); %for network density
% contents are in form userid,network_size,network_size_inc,betweenness,n_betweenness,density,brokerage,nbrokerage,transitivity
networkdata = textscan(fileid, '%s %f %f %f %f %f %f %f %f', 'Delimiter', ',','EmptyValue',NaN, 'HeaderLines',1);
fclose(fileid);
networkids = networkdata{1};
networkdata = [networkdata{6}, networkdata{2}];
% I only care about density and size respectively

count=0;
ndatatoadd = ones(1048575,2)*NaN;
[lis,loc]=ismember(ids,networkids);
count=0;
for i=1:1048575
    
    if (lis(i)==1)  
        count=count+1;
        ndatatoadd(i,:)=networkdata(loc(i),:);
    end
    
end
data = [data,ndatatoadd];

fileid=fopen('months.csv'); %for network density
monthdata = textscan(fileid, '%s %f', 'Delimiter', ',','EmptyValue',NaN, 'HeaderLines',1);
fclose(fileid);

mdatatoadd=ones(1048575,1)*NaN;
monthids=monthdata{1};
monthdata=monthdata{2};

[lis,loc]=ismember(ids,monthids);
count=0;
for i=1:1048575
    
    if (lis(i)==1)  
        count=count+1;
        mdatatoadd(i,:)=monthdata(loc(i),:);
    end
    
end
data = [data,mdatatoadd];
pruneindices=find(lis==1);
pruneddata= data(pruneindices,:);
prunedids=ids(pruneindices);

[llis,lloc]=ismember(prunedids,towrite(1));

load smallbig5.mat
count=0;
labels=ones(374965,5);
for i=1:374965
    
    if (llis(i)==1)  
        count=count+1;
        labels(i,:)=towrite{2}(lloc(i),:);
    end
    
end