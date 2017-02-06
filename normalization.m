function [normalized_training_data,normalized_test_data]=Normalization(vectors,method)
%Written by LiuKe
%vectors: normal cell data + cancer cell data (a num*6 matrix, the 1st column is the patientID)
%methhod: the normalization method
%normalized_training_data: the normalized version of training data
%normalized_test_data: the normalized version of test data


%find max, min, standard deviation, norm for vectors
[a_max,a_min,a_ave,a_delta]=Find_Max_Min_Ave(vectors(vectors(:,1)<12,2:end-4));%normalization parameter of training data (1-11)
[b_max,b_min,b_ave,b_delta]=Find_Max_Min_Ave(vectors(vectors(:,1)>=12,2:end-4));%normalization parameter of test data  (12-14)

normalized_training_data=vectors(vectors(:,1)<12,:);                       
normalized_test_data=vectors(vectors(:,1)>=12,:);                           
%method==1 normalizes feature vectors to zero mean and unit variance
if method==1
    normalized_training_data(:,2:end-4)=(vectors(vectors(:,1)<12,2:end-4)-a_ave)./a_delta;
    normalized_test_data(:,2:end-4)=(vectors(vectors(:,1)>=12,2:end-4)-b_ave)./b_delta;
end
%method==2 normalizes feature vectors to [0,1]
if method==2
    normalized_training_data(:,2:end-4)=(vectors(vectors(:,1)<12,2:end-4)-a_min)./(a_max-a_min);
    normalized_test_data(:,2:end-4)=(vectors(vectors(:,1)>=12,2:end-4)-b_min)./(b_max-b_min);
end
%method==3 normalizes feature vectors to unit vector length
if method==3
    a_norm=sqrt(sum(vectors(vectors(:,1)<12,2:end-4).^2,2));
    b_norm=sqrt(sum(vectors(vectors(:,1)>=12,2:end-4).^2,2));
    normalized_training_data(:,2:end-4)=vectors(vectors(:,1)<12,2:end-4)./a_norm;
    normalized_test_data(:,2:end-4)=vectors(vectors(:,1)>=12,2:end-4)./b_norm;
end
