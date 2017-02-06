function [test_result,confusion_matrix]=KNN(training_set,test_set,k)
%Witten by LiuKe
%training_set is used to calculate the cencer of each class
%test_set is used to be classified using minimun Mahalanobis Distance
%the 2 inputs are all 10 columns(1pateintID,5attributes,3locations,1truelabel)
%test_result has 11 columns (test_set + 1estimated label)
%k is the number of  nearest neighborhood
test_result=[test_set,zeros(size(test_set,1),1)];
for i=1:size(test_set,1)
    MD=pdist2(training_set(:,2:end-4),test_set(i,2:end-4));  %for each test feature, calculate the euclidean distance between all training data and itself 
    [~,index]=sort(MD);
     %if nearest neighbors are dominated by cancer cells
    if size(training_set(training_set(index(1:k),end)==1,:),1)>size(training_set(training_set(index(1:k),end)==-1,:),1) 
        test_result(i,end)=1;
    else %if nearest neighbors are dominated by normal cells
        test_result(i,end)=-1;
    end
end
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
