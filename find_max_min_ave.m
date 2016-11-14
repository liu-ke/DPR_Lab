function [max_5,min_5,ave_5,delta_5,norm_5]=find_max_min_ave(matrices)
%find maximum,minimum,average,delta,norm of ADC_value,Ktrans_value,Kep_value,PET_value,T2_value

%vectors should have 9 column dimensions
if size(matrices,2) ~=6
    disp('feature_length errors(which should be set to 6)');
    return;
end
max_5=max(matrices(:,2:6));
min_5=min(matrices(:,2:6));
ave_5=mean(matrices(:,2:6),1);
delta_5=std(matrices(:,2:6),0,1);%problematic

tmp=sum(matrices.^2);
norm_5=sqrt(tmp(1,2:6));

