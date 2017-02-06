function [max_5,min_5,ave_5,delta_5]=Find_Max_Min_Ave(matrices)
%Written by LiuKe
%find maximum,minimum,average,delta,norm of ADC_value,Ktrans_value,Kep_value,PET_value,T2_value

%vectors should have 5 column dimensions
if size(matrices,2) ~=5
    disp('feature_length errors(which should be set to 5)');
    return;
end
max_5=max(matrices(:,1:end));
min_5=min(matrices(:,1:end));
ave_5=mean(matrices(:,1:end),1);
delta_5=std(matrices(:,1:end),0,1);%problematic


