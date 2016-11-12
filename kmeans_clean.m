function [cleaned_set]=kmeans_clean(training_set,k)
%training_set has 6 columns(5 attributes, and 1 true label)
%k:number of clusters 
%random initialization->choose k training features as cluster centers randomly
centers=training_set(randperm(size(training_set,1),k),1:5);

%loop 20 times to cluster
for i=1:20
    distances=pdist2(training_set(:,1:5),centers);      %for each feature, calculate the distances between itself and every cluster center
    [~,index]=min(distances');                %assign each feature to a cluster whose center is the closest,1<=index<=k
    for j=1:k                                   %readjust the cluster centers
        centers(j,:)=mean(training_set(index==j,1:5));
    end
end
cleaned_set=[];
%remove the clusters in which there is only one class
for j=1:k                                   
    if sum(training_set(index==j,6),1)~=size(training_set(index==j,:),1) && sum(training_set(index==j,6),1)~=-size(training_set(index==j,:),1)
        cleaned_set=[cleaned_set;training_set(index==j,:)];
    end
end
