function[training_set,test_set]=datapartition(normal_features,cancer_features)
%training_set comes from patients 1-11 with 6 columns (5 attributes and 1 label)
%test_set comes from patients 12-14 (5 attributes and 1 label)
%normal cells labeled as -1, cancer_features labeled as +1

training_set=zeros(14,1,6); %number of training_set-1 row-6 columns
test_set=zeros(14,1,6);     %number of test_set-1 row-6 columns
for i=1:11
    training_set(i,:,:)=[normal_features(normal_features(:,1)==i,:);cancer_features(cancer_features(:,1)==i,:)];
end
for i=12:14
    test_set(i,:,:)=[normal_features(normal_features(:,1)==i,:);cancer_features(cancer_features(:,1)==i,:)];
end