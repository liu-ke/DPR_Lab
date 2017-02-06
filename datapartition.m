function[training_set,test_set]=DataPartition(training_features,test_features)
%Written by ChengQing
%training_set comes from patients 1-11 with 10 columns (1 patientID,5 attributes,3 locations and 1 label)
%test_set comes from patients 12-14 (1 patientID,5 attributes,3 locations and 1 label)
%normal cells labeled as -1, cancer_features labeled as +1

training_set=zeros(size(training_features));  %number of training_features-7 columns
test_set=zeros(size(test_features));          %number of test_features-7 columns
num_training_patients=11;
num_test_patients=3;
sub_row=zeros(num_training_patients,1);                    %index of rows in each training subset
for i=1:num_training_patients+1
    sub_row(i+1)=sub_row(i)+size(find(training_features(:,1)==i),1);
    training_set(sub_row(i)+1:sub_row(i+1),:)=training_features(training_features(:,1)==i,:);
end
sub_row=zeros(num_test_patients,1);                    %index of rows in each test subset
for i=1:num_test_patients
    sub_row(i+1)=sub_row(i)+size(find(test_features(:,1)==i+num_training_patients),1);
    test_set(sub_row(i)+1:sub_row(i+1),:)=test_features(test_features(:,1)==i+11,:);
end
