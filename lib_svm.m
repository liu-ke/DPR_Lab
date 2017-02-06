function[test_result,confusion_matrix]=Lib_Svm(train_set,test_set)
%Written by ChengQing
label_train=train_set(:,end);
label_test=test_set(:,end);
model=libsvmtrain(label_train,train_set(:,2:end-4),'-t 2');
%predict=ones(length(test_set),1);

    [predict,~,~]=libsvmpredict(label_test,test_set(:,2:end-4),model);

test_result=[test_set,predict];
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