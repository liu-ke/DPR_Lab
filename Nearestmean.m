function [test_result,confusion_matrix] = Nearestmean(training_set,test_set)
%Written by LiuKe
%training_set is used to calculate the cencer of each class
%test_set is used to be classified using minimun Mahalanobis Distance
%the 2 inputs are all 10 columns(1patientID,5attributes,3locations,1truelabel)
%test_result has 11 columns (test_set+1estimated label)

normal_set=training_set(training_set(:,end)==-1,:);  %seperate normal data and cancer data
cancer_set=training_set(training_set(:,end)==1,:);
normal_mean=mean(normal_set(:,2:end-4));            %compute centers of the 2 classes
cancer_mean=mean(cancer_set(:,2:end-4));

MD1=pdist2(test_set(:,2:end-4),normal_mean);  %calculate the mahalanobis distance between each feature and the normal-feature mean
MD2=pdist2(test_set(:,2:end-4),cancer_mean);  %calculate the mahalanobis distance between each feature and the cancer-feature mean

test_result=[test_set,zeros(size(test_set,1),1)]; %classify test data by minimun distance
test_result(MD1<MD2,end)=-ones(size(test_set(MD1<MD2,:),1),1);
test_result(MD1>=MD2,end)=ones(size(test_set(MD1>=MD2,:),1),1);
%compute classification confusion matrix
%confusion_matrix(1) is true negative rate
%confusion_matrix(1) is false positive rate
%confusion_matrix(1) is false negative rate
%confusion_matrix(1) is true positive rate
confusion_matrix=ones(4,1);
confusion_matrix(1)=size(test_result(test_result(:,end-1)==-1&test_result(:,end)==-1,:),1)/size(test_result(test_result(:,end-1)==-1,:),1);
confusion_matrix(2)=size(test_result(test_result(:,end-1)==-1&test_result(:,end)==1,:),1)/size(test_result(test_result(:,end-1)==-1,:),1);
confusion_matrix(3)=size(test_result(test_result(:,end-1)==1&test_result(:,end)==-1,:),1)/size(test_result(test_result(:,end-1)==1,:),1);
confusion_matrix(4)=size(test_result(test_result(:,end-1)==1&test_result(:,end)==1,:),1)/size(test_result(test_result(:,end-1)==1,:),1);



