function [features_a, features_b]=extraction(data,feature_length)
%extract and store medical voxel values and locations of prostate and cancer cells from all patients

%data:a dataset, in which are Images, LabelsA, LabelsB, and several medical images for every patient.
%healthy features(Labeled 1): features_a=[patientID,ADC_value,Ktrans_value,Kep_value,PET_value,T2_value]
%cancer features(Labeled 2): features_b=[patientID,ADC_value,Ktrans_value,Kep_value,PET_value,T2_value]

%In this lab, feature_length should be 9
if feature_length ~=6                   %length of each feature
    disp('feature_length errors(which should be set to 9)');
    return;
end



num_a=1;                                    %number of voxels in healthy prostate		
num_b=1;									%number of voxels in cancer prostate
features_a=ones(1,feature_length);						%the features of healthy prostate
features_b=ones(1,feature_length);						%the features of cancer prostate
for pat=1:size(data.dataset)                                        %loop for all patients (pat:patientID)
    max_T2=max(max(max(data.dataset{pat,1}.Image(:,:,:,5))));       %find the max_T2 for each patient
    min_T2=min(min(min(data.dataset{pat,1}.Image(:,:,:,5))));       %find the min_T2 for each patient
    if pat<=11                                          %extract data from 
        for i=1:size(data.dataset{pat,1}.LabelsA,1)                     %loop to search for the voxel locations of prostate tissue
            for j=1:size(data.dataset{pat,1}.LabelsA,2)
                for k=1:size(data.dataset{pat,1}.LabelsA,3)
                    if data.dataset{pat,1}.LabelsA(i,j,k)==1 && data.dataset{pat,1}.LabelsB(i,j,k)==1
                        ADC=data.dataset{pat,1}.Image(i,j,k,1);             %voxel values from 5 types of images
                        Ktrans=data.dataset{pat,1}.Image(i,j,k,2);
                        Kep=data.dataset{pat,1}.Image(i,j,k,3);
                        PET=data.dataset{pat,1}.Image(i,j,k,4);
                        T2=(data.dataset{pat,1}.Image(i,j,k,5)-min_T2)/(max_T2-min_T2);       %scaling T2 to the range [0,1]
                        features_a(num_a,:)=[pat,ADC,Ktrans,Kep,PET,T2];%store the features of healthy prostate
                        num_a=num_a+1;                                  %number of voxels of healthy prostate
                    end
                    if data.dataset{pat,1}.LabelsA(i,j,k)==2 && data.dataset{pat,1}.LabelsB(i,j,k)==2
                        ADC=data.dataset{pat,1}.Image(i,j,k,1);             %voxel values from 5 types of images
                        Ktrans=data.dataset{pat,1}.Image(i,j,k,2);
                        Kep=data.dataset{pat,1}.Image(i,j,k,3);
                        PET=data.dataset{pat,1}.Image(i,j,k,4);
                        T2=data.dataset{pat,1}.Image(i,j,k,5)/max_T2;       %scaling T2 to the range [0,1]
                        features_b(num_b,:)=[pat,ADC,Ktrans,Kep,PET,T2];%store the features of cancer prostate
                        num_b=num_b+1;                                  %number of voxels of cancer prostate
                    end
                end
            end
        end
    else            %extract test data
        ADC=data.dataset{pat,1}.Image(:,:,:,1);             %voxel values from 5 types of images
        Ktrans=data.dataset{pat,1}.Image(:,:,:,2);
        Kep=data.dataset{pat,1}.Image(:,:,:,3);
        PET=data.dataset{pat,1}.Image(:,:,:,4);
        T2=(data.dataset{pat,1}.Image(:,:,:,5)-min_T2)./(max_T2-min_T2);       %scaling T2 to the range [0,1]
        temp1=[repmat(pat,size(ADC(data.dataset{pat,1}.labelsHisto==1))),ADC(data.dataset{pat,1}.labelsHisto==1),Ktrans(data.dataset{pat,1}.labelsHisto==1),Kep(data.dataset{pat,1}.labelsHisto==1),PET(data.dataset{pat,1}.labelsHisto==1),T2(data.dataset{pat,1}.labelsHisto==1)];
        features_a=[features_a;temp1];
        temp2=[repmat(pat,size(ADC(data.dataset{pat,1}.labelsHisto==2))),ADC(data.dataset{pat,1}.labelsHisto==2),Ktrans(data.dataset{pat,1}.labelsHisto==2),Kep(data.dataset{pat,1}.labelsHisto==2),PET(data.dataset{pat,1}.labelsHisto==2),T2(data.dataset{pat,1}.labelsHisto==2)];
        features_b=[features_b;temp2];
    end
end
        