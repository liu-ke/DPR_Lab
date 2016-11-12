function[test_result,err_rate]=lib_svm(train_set,test_set)

label_train=train_set(:,end);
label_test=test_set(:,end);
model=libsvmtrain(label_train,train_set(:,1:end-1),'-t 2');
%predict=ones(length(test_set),1);

    [predict,accuracy,decision_values]=libsvmpredict(label_test,test_set(:,1:end-1),model);

test_result=[test_set,predict];

err_rate=size(test_result(test_result(:,end-1)~=test_result(:,end)),1)/size(test_result,1);    %compute classification error rate