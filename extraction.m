function [features_normal, features_cancer]=Extraction(input,feature_dim)
%Written by ChengQing
%Extract and store medical voxel values of normal and cancer cells from all patients

%data:a dataset, in which are Images, LabelsA, LabelsB, and several medical images for every patient.
%healthy features(Labeled 1): features_normal=[patientID,ADC_value,Ktrans_value,Kep_value,PET_value,T2_value,loc_x,loc_y,loc_z]
%cancer features(Labeled 2): features_cancer=[patientID,ADC_value,Ktrans_value,Kep_value,PET_value,T2_value,loc_x,loc_y,loc_z]

%In this lab, feature_length should be 9
if feature_dim ~=9                   %length of each feature
    disp('feature_length errors(which should be set to 9)');
    return;
end



num_a=1;                                    %number of voxels in healthy prostate		
num_b=1;									%number of voxels in cancer prostate
features_normal=ones(1,feature_dim);						%the features of healthy prostate
features_cancer=ones(1,feature_dim);						%the features of cancer prostate
for patientID=1:size(input.dataset)                                        %loop for all patients (patientID)
    max_T2=max(max(max(input.dataset{patientID,1}.Image(:,:,:,5))));       %find the max_T2 for each patient
    min_T2=min(min(min(input.dataset{patientID,1}.Image(:,:,:,5))));       %find the min_T2 for each patient
    if patientID<=11                                          %extract data from patients 1-11
        for i=1:size(input.dataset{patientID,1}.LabelsA,1)                     %loop to search for the voxel locations of prostate tissue
            for j=1:size(input.dataset{patientID,1}.LabelsA,2)
                for k=1:size(input.dataset{patientID,1}.LabelsA,3)
                    if input.dataset{patientID,1}.LabelsA(i,j,k)==1 && input.dataset{patientID,1}.LabelsB(i,j,k)==1
                        ADC=input.dataset{patientID,1}.Image(i,j,k,1);             %voxel values from 5 types of images
                        Ktrans=input.dataset{patientID,1}.Image(i,j,k,2);
                        Kep=input.dataset{patientID,1}.Image(i,j,k,3);
                        PET=input.dataset{patientID,1}.Image(i,j,k,4);
                        T2=(input.dataset{patientID,1}.Image(i,j,k,5)-min_T2)/(max_T2-min_T2);       %scaling T2 to the range [0,1]
                        features_normal(num_a,:)=[patientID,ADC,Ktrans,Kep,PET,T2,i,j,k];%store the features of healthy prostate
                        num_a=num_a+1;                                  %number of voxels of healthy prostate
                    end
                    if input.dataset{patientID,1}.LabelsA(i,j,k)==2 && input.dataset{patientID,1}.LabelsB(i,j,k)==2
                        ADC=input.dataset{patientID,1}.Image(i,j,k,1);             %voxel values from 5 types of images
                        Ktrans=input.dataset{patientID,1}.Image(i,j,k,2);
                        Kep=input.dataset{patientID,1}.Image(i,j,k,3);
                        PET=input.dataset{patientID,1}.Image(i,j,k,4);
                        T2=input.dataset{patientID,1}.Image(i,j,k,5)/max_T2;       %scaling T2 to the range [0,1]
                        features_cancer(num_b,:)=[patientID,ADC,Ktrans,Kep,PET,T2,i,j,k];%store the features of cancer prostate
                        num_b=num_b+1;                                  %number of voxels of cancer prostate
                    end
                end
            end
        end
    else            %extract test data
        ADC=input.dataset{patientID,1}.Image(:,:,:,1);             %voxel values from 5 types of images
        Ktrans=input.dataset{patientID,1}.Image(:,:,:,2);
        Kep=input.dataset{patientID,1}.Image(:,:,:,3);
        PET=input.dataset{patientID,1}.Image(:,:,:,4);
        T2=(input.dataset{patientID,1}.Image(:,:,:,5)-min_T2)./(max_T2-min_T2);       %scaling T2 to the range [0,1]
        %locations of normal prostate cells of validation patients (12-14)
        [normal_loc_x,normal_loc_y,normal_loc_z]=ind2sub(size(input.dataset{patientID,1}.labelsHisto),find(input.dataset{patientID,1}.labelsHisto==1));
        %locations of cancer prostate cells of validation patients (12-14)
        [cancer_loc_x,cancer_loc_y,cancer_loc_z]=ind2sub(size(input.dataset{patientID,1}.labelsHisto),find(input.dataset{patientID,1}.labelsHisto==2));
        temp1=[repmat(patientID,size(ADC(input.dataset{patientID,1}.labelsHisto==1))),ADC(input.dataset{patientID,1}.labelsHisto==1),Ktrans(input.dataset{patientID,1}.labelsHisto==1),Kep(input.dataset{patientID,1}.labelsHisto==1),PET(input.dataset{patientID,1}.labelsHisto==1),T2(input.dataset{patientID,1}.labelsHisto==1),normal_loc_x,normal_loc_y,normal_loc_z];
        features_normal=[features_normal;temp1];
        temp2=[repmat(patientID,size(ADC(input.dataset{patientID,1}.labelsHisto==2))),ADC(input.dataset{patientID,1}.labelsHisto==2),Ktrans(input.dataset{patientID,1}.labelsHisto==2),Kep(input.dataset{patientID,1}.labelsHisto==2),PET(input.dataset{patientID,1}.labelsHisto==2),T2(input.dataset{patientID,1}.labelsHisto==2),cancer_loc_x,cancer_loc_y,cancer_loc_z];
        features_cancer=[features_cancer;temp2];
    end
end
        