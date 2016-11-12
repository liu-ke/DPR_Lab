function [test_result,err_rate] = Nearestmean(training_set,test_set)
%training_set is used to calculate the cencer of each class
%test_set is used to be classified using minimun Mahalanobis Distance
%the 2 inputs are all 6 columns(5attributes + 1truelabel)
%test_result has 7 columns (test_set+1estimated label)

normal_set=training_set(training_set(:,6)==-1,:);  %seperate normal data and cancer data
cancer_set=training_set(training_set(:,6)==1,:);
normal_mean=mean(normal_set(:,1:5));            %compute centers of the 2 classes
cancer_mean=mean(cancer_set(:,1:5));

MD1=pdist2(test_set(:,1:5),normal_mean,'mahalanobis');  %calculate the mahalanobis distance between each feature and the normal-feature mean
MD2=pdist2(test_set(:,1:5),cancer_mean,'mahalanobis');  %calculate the mahalanobis distance between each feature and the cancer-feature mean

test_result=zeros(size(test_set,1),size(test_set,2)+1); %classify test data by minimun distance
test_result(MD1<MD2,:)=[test_set(MD1<MD2,:),-ones(size(test_set(MD1<MD2,:),1),1)];
test_result(MD1>=MD2,:)=[test_set(MD1>=MD2,:),ones(size(test_set(MD1>=MD2,:),1),1)];

err_rate=size(test_result(test_result(:,6)~=test_result(:,7)),1)/size(test_result,1);    %compute classification error rate
