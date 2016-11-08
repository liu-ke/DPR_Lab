function [normalized_a,normalized_b]=normalization(vectors_a,vectors_b,method)
%normalized_a is the normalized version of vectors_a
%normalized_b is the normalized version of vectors_b
%method==1 normalizes feature vectors to zero mean and unit variance
%method==2 normalizes feature vectors to [0,1]
%method==3 normalizes feature vectors to unit vector length

%find max, min, standard deviation, norm for vectors_a and vectors_b
[a_max,a_min,a_ave,a_delta,a_norm]=find_max_min_ave(vectors_a);
[b_max,b_min,b_ave,b_delta,b_norm]=find_max_min_ave(vectors_b);

normalized_a=vectors_a;
normalized_b=vectors_b;
if method==1
    for i=1:size(vectors_a,1)
        normalized_a(i,5:9)=(vectors_a(i,5:9)-a_ave)./a_delta;
    end
    for i=1:size(vectors_b,1)
        normalized_b(i,5:9)=(vectors_b(i,5:9)-b_ave)./b_delta;
    end
end
if method==2
    for i=1:size(vectors_a,1)
        normalized_a(i,5:9)=(vectors_a(i,5:9)-a_min)./(a_max-a_min);
    end
    for i=1:size(vectors_b,1)
        normalized_b(i,5:9)=(vectors_b(i,5:9)-b_min)./(b_max-b_min);
    end
end
if method==3
    for i=1:size(vectors_a,1)
        normalized_a(i,5:9)=vectors_a(i,5:9)./a_norm;
    end
    for i=1:size(vectors_b,1)
        normalized_b(i,5:9)=vectors_b(i,5:9)./b_norm;
    end
end