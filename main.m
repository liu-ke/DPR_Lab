clear;
clc;
med_dataset=load('F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\medData\dataset.mat');%path of dataset
%1 Feature Extraction(Written by ChengQing)
% (patientID,ADC_value,Ktrans_value,Kep_value,PET_value,T2_value,loc_x,loc_y,loc_z)
% save features to speed up 
% feature_dim=9;
% [normal_features,cancer_features]=Extraction(med_dataset,feature_dim);
% save('features.mat','normal_features','cancer_features');
load('features.mat');
% normal_features labeled as -1, cancer_features labeled as 1
features=[normal_features,-ones(size(normal_features,1),1);cancer_features,ones(size(cancer_features,1),1)];

%2 Feature Normalization(Written by LiuKe)
normalization_method=2;
[normalized_training_features,normalized_test_features]=Normalization(features,normalization_method);

%3 Outlier Detection(Written by LiuKe)
% detection_method==1: Detect outliers by Mahalanobis Distance;detection_method==2: Detect outliers by Robust Distance
detection_method=1; 
[cleaned_training_features,normal_outliers_percent_training,cancer_outliers_percent_training]=OutlierDetection(normalized_training_features,detection_method);
% no need for outlier detection in test set 
% [cleaned_test_features,normal_outliers_percent_test,cancer_outliers_percent_test]=OutlierDetection(normalized_test_features,detection_method);

%4 Data Partitioning(Written by ChengQing)
[training_set,test_set]=DataPartition(cleaned_training_features,normalized_test_features);

%5 Training set selection(Written by LiuKe)
% clean training data using kmeans clustering
% we should have used KmeansClean with k=num_training_set/2=170000 for one time, due to limited storage, we use KmeansClean for 3 times with k=3000 
k=3000;                                  
[temp1]=KmeansClean( training_set(training_set(:,1)<4,:) ,k);
[temp2]=KmeansClean( training_set(training_set(:,1)>=4&training_set(:,1)<8,:) ,k);
[temp3]=KmeansClean( training_set(training_set(:,1)>=8,:) ,k);
selected_training_set=[temp1;temp2;temp3];

%6 Classifiers(Written by LiuKe)
% using NearestMean (with training set selection)
[test_results_nm,confusion_matrix_nm]=NearestMean(selected_training_set,test_set);
% using kNN (with training set selection)
kNN_k=400;
[test_results_knn,confusion_matrix_knn]=KNN(selected_training_set,test_set,kNN_k);
% using libSVM (with training set selection)
[test_results_svm,confusion_matrix_svm]=Lib_Svm(selected_training_set,test_set);
% training & test stage using NearestMean (without training set selection)
[test_results_nm_no_training_selection,confusion_matrix_nm_no_training_selection]=NearestMean(training_set,test_set);
% training & test stage using kNN (without training set selection)
[test_results_knn_no_training_selection,confusion_matrix_knn_no_training_selection]=KNN(training_set,test_set,kNN_k);
% training & test using libSVM (without training set selection)
[test_results_svm_no_training_selection,confusion_matrix_svm_no_training_selection]=Lib_Svm(training_set,test_set);
% save error rate (for further comparison)
save('confusion_matrix.mat','confusion_matrix_nm','confusion_matrix_knn','confusion_matrix_svm','confusion_matrix_knn_no_training_selection','confusion_matrix_svm_no_training_selection','confusion_matrix_nm_no_training_selection');
save('test_results.mat','test_results_nm','test_results_knn','test_results_svm','test_results_nm_no_training_selection','test_results_knn_no_training_selection','test_results_svm_no_training_selection');
load('confusion_matrix.mat');
load('test_results.mat');

% 9 Visualization & Evaluation(Written by ChengQing)
% true_labels is a cell, which contains 12-14 true lable data, same cases for labels_A and labels_B
true_labels={med_dataset.dataset{12,1}.labelsHisto;med_dataset.dataset{13,1}.labelsHisto;med_dataset.dataset{14,1}.labelsHisto};
labels_A={med_dataset.dataset{12,1}.LabelsA;med_dataset.dataset{13,1}.LabelsA;med_dataset.dataset{14,1}.LabelsA};
labels_B={med_dataset.dataset{12,1}.LabelsB;med_dataset.dataset{13,1}.LabelsB;med_dataset.dataset{14,1}.LabelsB};
% estimated_labels is a matrix with 5 columns(1patientID,3locations,1estimated label), which contains data from 12-14 patients
estimated_labels=[test_results_knn_no_training_selection(:,1),test_results_knn_no_training_selection(:,7:9),test_results_knn_no_training_selection(:,end)];
% estimated_labels=[test_results_svm_no_training_selection(:,1),test_results_svm_no_training_selection(:,7:9),test_results_svm_no_training_selection(:,end)];
% estimated_labels=[test_results_nm_no_training_selection(:,1),test_results_nm_no_training_selection(:,7:9),test_results_nm_no_training_selection(:,end)];
% evaluate 3 classifiers with no training set selection
figure(1);
title('Evaluation');
xlabel('False Positive');
ylabel('True Positive');
plot(confusion_matrix_knn_no_training_selection(2),confusion_matrix_knn_no_training_selection(4),'ob');
hold on;
plot(confusion_matrix_knn(2),confusion_matrix_knn(4),'or');
hold on;
plot(confusion_matrix_svm_no_training_selection(2),confusion_matrix_svm_no_training_selection(4),'+b');
hold on;
plot(confusion_matrix_svm(2),confusion_matrix_svm(4),'+r');
hold on;
plot(confusion_matrix_nm(2),confusion_matrix_nm(4),'*b');
hold on;
legend('without training selection(KNN)','with training selection(KNN)','without training selection(SVM)','with training selection(SVM)','without training selection(NM)');
plot([0,0,1,1],[0,1,0,1],'.');
hold off;
%Visualization for final results
images=Visualization(true_labels,estimated_labels,labels_A,labels_B);


%7 Feature selection (using KNN classifier)(Written by LiuKe)
%feature_dim=size(training_set,2);                                            %should be 5
feature_dim=5;
confusion_matrix_knn_selected_features=zeros(4,10);
n=1;
kNN_k=400;
for i=2:5               %iterate for all possibilities of 2 attributes as a feature
    for j=(i+1):6
        selected_training_features=[training_set(:,1),training_set(:,i),training_set(:,j),training_set(:,end-4:end)];
        selected_test_features=[test_set(:,1),test_set(:,i),test_set(:,j),test_set(:,end-4:end)];
        [~,confusion_matrix_knn_selected_features(:,n)]=KNN(selected_training_features,selected_test_features,kNN_k);
        n=n+1;
    end
end
save('confusion_matrix_selected_features','confusion_matrix_knn_selected_features');
load('confusion_matrix_selected_features');
figure(2);
hold off;
title('Feature Selection');
plot(confusion_matrix_knn_selected_features(2,1:10),confusion_matrix_knn_selected_features(4,1:10),'og');
hold on;
for n=1:10
    text(confusion_matrix_knn_selected_features(2,n),confusion_matrix_knn_selected_features(4,n),{n});
end
plot([0,0,1,1],[0,1,0,1],'.');

%8 Parameter estimation(Written by ChengQing)
parameter_tuning_k=[10,100,200,400,800,1600,3200,6400,12800,25600];
for kNN_k=parameter_tuning_k
    [test_results_k_selection,confusion_matrix_k_selection]=KNN(training_set,test_set,kNN_k);
    name_results=['test_results',num2str(kNN_k),'.mat'];
    name_matrix=['confusion_matrix',num2str(kNN_k),'.mat'];
    save(name_matrix,'confusion_matrix_k_selection');
    save(name_results,'test_results_k_selection');
end
figure(3);
title('Evaluation');
xlabel('False Positive');
ylabel('True Positive');
for kNN_k=parameter_tuning_k
    name_matrix=['confusion_matrix',num2str(kNN_k),'.mat'];
    load(name_matrix);
    plot(confusion_matrix_k_selection(2),confusion_matrix_k_selection(4),'*b');
    hold on;
end
legend('k=10','k=100','k=200','k=400','k=800','k=1600','k=3200','k=6400','k=12800','k=25600');
plot([0,0,1,1],[0,1,0,1],'.');

