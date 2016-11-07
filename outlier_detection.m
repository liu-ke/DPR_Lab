function [outliers1,outliers2,percent1,percent2]=outlier_detection(input1,input2,method)
%
%input should have 9 columns
input1_mean=mean(input1(:,5:9),1);
input2_mean=mean(input2(:,5:9),1);
input1_cov=cov(input1(:,5:9),1);
input2_cov=cov(input2(:,5:9),1);
if method==1
    MD1=pdist2(input1(:,5:9),'mahalanobis',input1_mean);
    MD2=pdist2(input2(:,5:9),'',input2_mean);
    thres1=max(MD1)*0.9;
    thres2=max(MD2)*0.9;
    outliers1=MD1(MD1>thres1);
    outliers2=MD2(MD2>thres2);
    percent1=size(outliers1)/size(MD1);
    percent2=size(outliers2)/size(MD2);
end
if method==2
    
end
