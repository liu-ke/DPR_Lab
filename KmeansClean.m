function [cleaned_set]=KmeansClean(training_set,k)
%Written by LiuKe
%training_set has 10 columns(1 patientID,5 attributes,3 locations, and 1 true label)
%k:number of clusters 
%cleaned_set: the dataset after training set selection 
cleaned_set=[];
%use the Kmeans provided by MATLAB (idx:N*1)
[idx,~]=kmeans(training_set(:,2:end-4),k);
%replace the training samples inside only-one-class clusters with its cluster center, retain those in multi-classes clusters.
for j=1:k
    if sum(training_set(idx(:,1)==j,end),1)~=size(training_set(idx(:,1)==j,:),1) && sum(training_set(idx(:,1)==j,end),1)~=-size(training_set(idx(:,1)==j,:),1)
        cleaned_set=[cleaned_set;training_set(idx(:,1)==j,:)];
    end
end
