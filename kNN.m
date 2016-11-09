function [test_result,err_rate]=kNN(training_set,test_set,k)
%training_set is used to calculate the cencer of each class
%test_set is used to be classified using minimun Mahalanobis Distance
%the 2 inputs are all 6 columns(5attributes + 1truelabel)
%test_result has 7 columns (test_set+1estimated label)
%k is the number of  nearest neighborhood
test_result=[test_set,0];
for i=1:size(test_set,1)
    MD=pdist2(training_set,test_set(i,1:5),'mahalanobis');  %for each test feature, calculate the euclidean distance between all training data and itself 
    [MD_sorted,index]=sort(MD);
    if length(training(index(1:k),6)==1)>length(training(index(1:k),6)==0)  %if nearest neighbors are dominated by cancer cells
        test_result(i)=[test_set(i),1];
    else                                                                    %if nearest neighbors are dominated by normal cells
        test_result(i)=[test_set(i),0];
    end
end

err_rate=size(test_result(test_result(:,6)~=test_result(:,7)),1)/size(test_set,1);