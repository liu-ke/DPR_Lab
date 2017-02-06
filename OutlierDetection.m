function [cleaned_features,normal_outliers_percent,cancer_outliers_percent]=OutlierDetection(input,method)
%Written by LiuKe
%cleaned_features; each with 10 columns [PatientID,ADC_value,Ktrans_value,Kep_value,PET_value,T2_value,loc_x,loc_y,loc_z,label]
%input: normalized training or test features(10 columns)
%method==1 uses Mahalanobis Distance, method==2 uses Robust Distance to remove out liers
input1=input(input(:,end)==-1,:);                   %normal cell features
input2=input(input(:,end)==1,:);                    %cancer cell features


%outlier detection using Mahalanobis Distance
if method==1
    input1_mean=mean(input1(:,2:end-4),1);              %compute the mean feature for input1 and input2 
    input2_mean=mean(input2(:,2:end-4),1);
    MD1=pdist2(input1(:,2:end-4),input1_mean,'mahalanobis');    %calculate Mahalanobis Distance between each feature and mean feature
    MD2=pdist2(input2(:,2:end-4),input2_mean,'mahalanobis');
    thres1=mean(MD1)*1.5;                                   %outlier threshold is set to the 1.4 times mean distance
    thres2=mean(MD2)*1.5;
    outliers1(MD1>thres1,:)=1;                                %if MD> threshold, it is labeled 1 as an outlier; otherwise labeled 0
    outliers2(MD2>thres2,:)=1;
    normal_outliers_percent=size(outliers1(outliers1==1))/size(MD1);                     %compute the percentage of outliers
    cancer_outliers_percent=size(outliers2(outliers2==1))/size(MD2);
end
%outlier detection using Robust Detection
if method==2
    [~,~,RD1,outliers1]=robustcov(input1(:,2:end-4));      %compute the Robust Distance for input1 and input2, using robust mean and robust covariance
	[~,~,RD2,outliers2]=robustcov(input2(:,2:end-4));      %threshold for outliers is default offered by robustcov() 
    %thres1=mean(RD1)*1.6;
    %thres2=mean(RD2)*1.6;
    normal_outliers_percent=size(outliers1(outliers1==1))/size(RD1);       %compute the percentage of outliers
    cancer_outliers_percent=size(outliers2(outliers2==1))/size(RD2);
end
%outliers removal
input1(outliers1==1,:)=[];                                  %remove outliers
input2(outliers2==1,:)=[];
cleaned_features=[input1;input2];
