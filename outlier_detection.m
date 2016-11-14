function [new_features1,new_features2,outliers1,outliers2,percent1,percent2]=outlier_detection(input1,input2,method)

%new_features1 contains normal cell features,each with 6 columns [PatientID,ADC_value,Ktrans_value,Kep_value,PET_value,T2_value]
%new_features2 contains cancer cell features,each with 6 columns [PatientID,ADC_value,Ktrans_value,Kep_value,PET_value,T2_value]
%input1 and input2 should have 9 columns
%method==1 uses Mahalanobis Distance, method==2 uses Robust Distance to remove out liers

input1_mean=mean(input1(:,2:6),1);              %compute the mean feature for input1 and input2 
input2_mean=mean(input2(:,2:6),1);

%outlier detection using Mahalanobis Distance
if method==1
    MD1=pdist2(input1(1:11,2:6),input1_mean,'mahalanobis');    %calculate Mahalanobis Distance between each feature and mean feature
    MD2=pdist2(input2(1:11,2:6),input2_mean,'mahalanobis');
    %thres1=chi2cdf(MD1,);
    %thres2=chi2cdf(MD2,);
    thres1=mean(MD1)*1.4;                                   %outlier threshold is set to the 1.6 times mean distance
    thres2=mean(MD2)*1.4;
    outliers1(MD1>thres1,:)=1;                                %if MD> threshold, it is labeled 1 as an outlier; otherwise labeled 0
    outliers1(MD1<=thres1,:)=0;
    outliers2(MD2>thres2,:)=1;
    outliers2(MD2<=thres2,:)=0;
    percent1=size(outliers1(outliers1==1))/size(MD1);                     %compute the percentage of outliers
    percent2=size(outliers2(outliers2==1))/size(MD2);
end
%outlier detection using Robust Detection
if method==2
    [cov1,mu1,RD1,outliers1]=robustcov(input1(input1(:,1)<12,2:6));      %computer the Robust Distance for input1 and input2, using robust mean and robust covariance
	[cov2,mu2,RD2,outliers2]=robustcov(input2(input2(:,1)<12,2:6));      %threshold for outliers is default offered by robustcov() 
    %thres1=mean(RD1)*1.6;
    %thres2=mean(RD2)*1.6;
    percent1=size(outliers1(outliers1==1))/size(RD1);       %compute the percentage of outliers
    percent2=size(outliers2(outliers2==1))/size(RD2);
end
%outliers removal
input1(outliers1==1,:)=[];                                  %remove outliers
input2(outliers2==1,:)=[];
new_features1=[input1(:,1),input1(:,2:6)];                  %remove location information in inputs.
new_features2=[input2(:,1),input2(:,2:6)];