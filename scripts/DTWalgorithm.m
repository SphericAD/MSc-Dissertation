function  distortion = DTWalgorithm(seq1,seq2)
tic
%DTW algorithm for Local+Global features

% seq1 now is a r by n matrix and seq2 is an r by m matrix where r denote dimension of each feature vector(frame) 
% and n and m denote the length of the sequences
[r2,n]=size(seq1);
[r2, m]= size(seq2);
%adding a warping window to speed up computation
if n>m
w = min(fix(0.1*n),abs(n-m));
[r2,n]=size(seq1);

else
w = min(fix(0.1*m),abs(n-m));

[r2, m]= size(seq2);
end

 

seq1=[zeros(r2,1) seq1];
seq2=[zeros(r2,1) seq2];
%Initialize the DTW cost matrix
DTW = zeros (n+1,m+1);

for l =2 :m+1
    DTW(1,l)=Inf;
end
for l =2 :n+1
    DTW(l,1)=Inf;
end
DTW(1,1)=0;

for l=2:n+1
    for j=max(2,l-w) :min(m+1,l+w+1)
     %using  normal DTW with warping window
      DTW(l,j)= sum((seq1(:,l)-seq2(:,j)).^2) + min ([DTW(l-1,j),DTW(l-1,j-1),DTW(l,j-1)]);
    end
end

%Making more adjustments to reduce time complexity
DTW=DTW(2:end,2:end);
distortion =DTW(find(DTW,1,'last'))/(n+m);
%distortion=DTW(n+1,m+1)/(n+m);

clearvars DTW seq1 seq2 
toc
end