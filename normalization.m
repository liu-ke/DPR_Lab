function [normalized_a,normalized_b]=normalization(vectors_a,vectors_b,method)
%
%
[a_max,a_min,a_ave,a_delta,a_norm]=find_max_min_ave(vectors_a);
[b_max,b_min,b_ave,b_delta,b_norm]=find_max_min_ave(vectors_b);

normalized_a=vectors_a;
normalized_b=vectors_b;
if method==1
    for i=1:size(vectors_a,1)
        normalized_a(i,5)=(vectors_a(i,5)-a_ave(1))/a_delta(1);
        normalized_a(i,6)=(vectors_a(i,6)-a_ave(2))/a_delta(2);
        normalized_a(i,7)=(vectors_a(i,7)-a_ave(3))/a_delta(3);
        normalized_a(i,8)=(vectors_a(i,8)-a_ave(4))/a_delta(4);
        normalized_a(i,9)=(vectors_a(i,9)-a_ave(5))/a_delta(5);
    end
    for i=1:size(vectors_b,1)
        normalized_b(i,5)=(vectors_b(i,5)-b_ave(1))/b_delta(1);
        normalized_b(i,6)=(vectors_b(i,6)-b_ave(2))/b_delta(2);
        normalized_b(i,7)=(vectors_b(i,7)-b_ave(3))/b_delta(3);
        normalized_b(i,8)=(vectors_b(i,8)-b_ave(4))/b_delta(4);
        normalized_b(i,9)=(vectors_b(i,9)-b_ave(5))/b_delta(5);
    end
end
if method==2
    for i=1:size(vectors_a,1)
        normalized_a(i,5)=(vectors_a(i,5)-a_min(1))/(a_max(1)-a_min(1));
        normalized_a(i,6)=(vectors_a(i,6)-a_min(2))/(a_max(2)-a_min(2));
        normalized_a(i,7)=(vectors_a(i,7)-a_min(3))/(a_max(3)-a_min(3));
        normalized_a(i,8)=(vectors_a(i,8)-a_min(4))/(a_max(4)-a_min(4));
        normalized_a(i,9)=(vectors_a(i,9)-a_min(5))/(a_max(5)-a_min(5));
    end
    for i=1:size(vectors_b,1)
        normalized_b(i,5)=(vectors_b(i,5)-b_min(1))/(b_max(1)-b_min(1));
        normalized_b(i,6)=(vectors_b(i,6)-b_min(2))/(b_max(2)-b_min(2));
        normalized_b(i,7)=(vectors_b(i,7)-b_min(3))/(b_max(3)-b_min(3));
        normalized_b(i,8)=(vectors_b(i,8)-b_min(4))/(b_max(4)-b_min(4));
        normalized_b(i,9)=(vectors_b(i,9)-b_min(5))/(b_max(5)-b_min(5));
    end
end
if method==3
    for i=1:size(vectors_a,1)
        for j=5:9
        normalized_a(i,j)=vectors_a(i,j)/a_norm(j-4);
        end
    end
    for i=1:size(vectors_b,1)
        for j=5:9
        normalized_b(i,j)=vectors_b(i,j)/b_norm(j-4);
        end
    end
end