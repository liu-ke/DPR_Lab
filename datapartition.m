function[training_set,test_set]=datapartition(normal_features,cancer_features)
%training_set comes from patients 1-11 with 7 columns (1 patientID,5 attributes,and 1 label)
%test_set comes from patients 12-14 (1 patientID,5 attributes,and 1 label)
%normal cells labeled as -1, cancer_features labeled as +1
normal_features=[normal_features,-ones(size(normal_features,1),1)];
cancer_features=[cancer_features,ones(size(cancer_features,1),1)];
training_row=size(find(cancer_features(:,1)>0&cancer_features(:,1)<12),1)+size(find(normal_features(:,1)>0&normal_features(:,1)<12),1);
test_row=size(find(cancer_features(:,1)>11&cancer_features(:,1)<15),1)+size(find(normal_features(:,1)>11&normal_features(:,1)<15),1);
training_set=zeros(training_row,7);  %number of training_set-training_row-6 columns
test_set=zeros(test_row,7);          %number of test_set-test_row-6 columns
sub_row=zeros(12,1);                    %index of rows in each training subset
for i=1:11
    sub_row(i+1)=sub_row(i)+size(find(normal_features(:,1)==i),1)+size(find(cancer_features(:,1)==i),1);
    training_set(sub_row(i)+1:sub_row(i+1),:)=[normal_features(normal_features(:,1)==i,:);cancer_features(cancer_features(:,1)==i,:)];
end
sub_row=zeros(3,1);                    %index of rows in each test subset
for i=1:3
    sub_row(i+1)=sub_row(i)+size(find(normal_features(:,1)==i+11),1)+size(find(cancer_features(:,1)==i+11),1);
    test_set(sub_row(i)+1:sub_row(i+1),:)=[normal_features(normal_features(:,1)==i+11,:);cancer_features(cancer_features(:,1)==i+11,:)];
end