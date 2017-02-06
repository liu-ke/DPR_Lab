function[output]=Visualization(true_labels,estimated_labels,labels_A,labels_B)
%Witten by ChengQing
%true_lables is a cell, which contains 12-14 true lable data
%estimated_lables is a matrix with 5 columns(1patientID,3locations,1estimated label), which contains data from 12-14 patients
output=cell(size(true_labels));
images=cell(size(true_labels));
for i=1:size(true_labels)
    images{i,1}(:,:,:,1)=true_labels{i,1};         %for true lables
    images{i,1}(:,:,:,2)=zeros(size(true_labels{i,1}));   %for estimated lables
    images{i,1}(:,:,:,3)=labels_A{i,1};          %for labels_A
    images{i,1}(:,:,:,4)=labels_B{i,1};          %for labels_B
    estimated_cancer_loc=estimated_labels(estimated_labels(:,1)==i+11&estimated_labels(:,end)==1,2:4);%locations of estimated cancer cells
    estimated_normal_loc=estimated_labels(estimated_labels(:,1)==i+11&estimated_labels(:,end)==-1,2:4);%locations of estimated cancer cells
    estimated_cancer_index=sub2ind(size(images{i,1}(:,:,:,2)),estimated_cancer_loc(:,1)',estimated_cancer_loc(:,2)',estimated_cancer_loc(:,3)');%transform subscripts to index
    estimated_normal_index=sub2ind(size(images{i,1}(:,:,:,2)),estimated_normal_loc(:,1)',estimated_normal_loc(:,2)',estimated_normal_loc(:,3)');%transform subscripts to index
    temp=images{i,1}(:,:,:,2);
    temp(estimated_cancer_index)=2;%estimated cancer cells labled as 2
    temp(estimated_normal_index)=1;%estimated normal cells labled as 1
    images{i,1}(:,:,:,2)=temp;
    output{i,1}=imagine(images{i,1});
end








