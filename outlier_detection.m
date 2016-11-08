function [outliers1,outliers2,percent1,percent2]=outlier_detection(input1,input2,method)
%
%input should have 9 columns
input1_mean=mean(input1(:,5:9),1);
input2_mean=mean(input2(:,5:9),1);
input1_cov=cov(input1(:,5:9),1);
input2_cov=cov(input2(:,5:9),1);
if method==1
    MD1=pdist2(input1(:,5:9),input1_mean,'mahalanobis');
    MD2=pdist2(input2(:,5:9),input2_mean,'mahalanobis');
    %thres1=chi2cdf(MD1,);
    %thres2=chi2cdf(MD2,);
    thres1=mean(MD1)*1.6;
    thres2=mean(MD2)*1.6;
    outliers1=MD1(MD1>thres1);
    outliers2=MD2(MD2>thres2);
    percent1=size(outliers1)/size(MD1);
    percent2=size(outliers2)/size(MD2);
end
if method==2
    [cov1,mu1,RD1,outliers1]=robustcov(input1(:,5:9));
	[cov2,mu2,RD2,outliers2]=robustcov(input2(:,5:9));
    thres1=mean(RD1)*1.6;
    thres2=mean(RD2)*1.6;
    %outliers1=RD1(RD1>thres1);
    %outliers2=RD2(RD2>thres2);
    percent1=size(outliers1)/size(RD1);
    percent2=size(outliers2)/size(RD2);
end
