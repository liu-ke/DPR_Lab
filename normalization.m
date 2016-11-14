function [out_a,out_b]=normalization(vectors_a,vectors_b,method)
%normalized_a is the normalized version of vectors_a
%normalized_b is the normalized version of vectors_b
%method==1 normalizes feature vectors to zero mean and unit variance
%method==2 normalizes feature vectors to [0,1]
%method==3 normalizes feature vectors to unit vector length

%find max, min, standard deviation, norm for vectors_a and vectors_b
vectors=[vectors_a,-ones(size(vectors_a,1),1);vectors_b,ones(size(vectors_b,1),1)];
[a_max,a_min,a_ave,a_delta,a_norm]=find_max_min_ave(vectors(vectors(:,1)<12,1:end-1));%normalization parameter of training data 
[b_max,b_min,b_ave,b_delta,b_norm]=find_max_min_ave(vectors(vectors(:,1)>=12,1:end-1));%normalization parameter of test data 

normalized_a=vectors(vectors(:,1)<12,:);                            %normalized training data
normalized_b=vectors(vectors(:,1)>=12,:);                           %normalized test data
if method==1
    normalized_a(:,2:6)=(vectors(vectors(:,1)<12,2:6)-a_ave)./a_delta;
    normalized_b(:,2:6)=(vectors(vectors(:,1)>=12,2:6)-b_ave)./b_delta;
end
if method==2
    normalized_a(:,2:6)=(vectors(vectors(:,1)<12,2:6)-a_min)./(a_max-a_min);
    normalized_b(:,2:6)=(vectors(vectors(:,1)>=12,2:6)-b_min)./(b_max-b_min);
end
if method==3
    normalized_a(:,2:6)=vectors(vectors(:,1)<12,2:6)./a_norm;
    normalized_b(:,2:6)=vectors(vectors(:,1)>=12,2:6)./b_norm;
end

out_a=[normalized_a(normalized_a(:,end)==-1,1:end-1);normalized_b(normalized_b(:,end)==-1,1:end-1)];
out_b=[normalized_a(normalized_a(:,end)==1,1:end-1);normalized_b(normalized_b(:,end)==1,1:end-1)];