function distortion = DTWalgorithm(seq1,seq2)
%DTW algorithm for Local+Global features
seq1=seq1';
seq2=seq2';


% seq1 now is a r by n matrix and seq2 is an r by m matrix where r denote dimension of each feature vector(frame) 
% and n and m denote the length of the sequences

[r,n]=size(seq1);
[r, m]= size(seq2);








%Initialize the DTW cost matrix
DTW = zeros (n+1,m+1);
for i =2 :m+1
    DTW(1,i)=Inf;
end
for i =2 :n+1
    DTW(i,1)=Inf;
end
DTW(1,1)=0;

for i=2:m+1
    DTW(:,i)= (seq1 -ones(n+1,1)*seq2(i)).^2;
end




%for i=2:n+1
 %   for j=2:m+1
        %using local + global distance
  %      DTW(i,j)= sum((seq1G(:,i)-seq2G(:,j)).^2)+sum((seq1L(:,i)-seq2L(:,j)).^2) + min ([DTW(i-1,j),DTW(i-1,j-1),DTW(i,j-1)]);
        %using euclidean metric where each frame is a value.
        %DTW(i,j)= (seq1(i)-seq2(j)).^2 + min ([DTW(i-1,j),DTW(i-1,j-1),DTW(i,j-1)]);
   % end
%end

distortion=DTW(n+1,m+1)/(n+m);
clearvars DTW seq1 seq2 
end