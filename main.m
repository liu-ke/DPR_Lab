clear;
clc;
med_dataset=load('F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\medData\dataset.mat');
%save('med_dataset.mat','med_dataset');
%(patientID;cell_location_i;cell_location_j;cell_location_k;ADC_value;Ktrans_value;Kep_value;PET_value;T2_value)
%feature_length=9;
%[features_a,features_b]=extraction(med_dataset,feature_length);
%save('features.mat','features_a','features_b');
load('features.mat')
normalize_method=3;
[normalized_normal_features,normalized_cancer_features]=normalization(features_a,features_b,normalize_method);

detection_method=2;
[normal_features,cancer_features,outliers_a,outliers_b,percent_a,percent_b]=outlier_detection(normalized_normal_features,normalized_cancer_features,detection_method);
[training_set,test_set]=datapartition(normal_features,cancer_features);

training_set(:,1)=[];           %remove PatientID
test_set(:,1)=[];
k=10;
[cleaned_set]=kmeans_clean(training_set,k);%clean training data using kmeans clustering
%training stage using kNN
kNN_k=10;
[test_result,err_rate]=kNN(cleaned_set,test_set,kNN_k);
%training & test stage using NearestMean
[test_result,err_rate]=Nearestmean(cleaned_set,test_set);






