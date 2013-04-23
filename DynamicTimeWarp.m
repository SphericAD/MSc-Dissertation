
function distance = DynamicTimeWarp(pathname1,pathname2)
tic
%pathnames correponds to the local directory path of the speech files

%convert speech files to samples;
%for sph files%
[sample1, fs]= readsph(pathname1);
[sample2, fs2] =readsph(pathname2);

% for wav files
%[sample1, fs]= wavread(pathname1);
%[sample2, fs2] =wavread(pathname2);


%extract MFCC vectors 
seq1 = melfcc(sample1,fs);
seq2= melfcc(sample2,fs2);

clearvars sample1 sample2 pathname1 pathname2  fs fs2 

%perform dyanamic timewarping
distance = log(DTWalgorithm(seq1,seq2)+1);


clearvars seq1 seq2
toc
end

function distortion = DTWalgorithm(seq1,seq2)
% seq1 is r by n matrix and seq2 is an r by m matrix where r denote dimension of each feature vector 
% and n and m denote the length of the sequences

[r,n]=size(seq1);
[r m]= size(seq2);
seq1=[zeros(r,1) seq1];
seq2=[zeros(r,1),seq2];
%Initialize the DTW cost matrix
DTW = zeros (n+1,m+1);
for i =2 :m+1
    DTW(1,i)=Inf;
end
for i =2 :n+1
    DTW(i,1)=Inf;
end
DTW(1,1)=0;

for i=2:n+1
    for j=2:m+1
        DTW(i,j)= sum((seq1(:,i)-seq2(:,j)).^2) + min ([DTW(i-1,j),DTW(i-1,j-1),DTW(i,j-1)]);
    end
end

distortion=DTW(n+1,m+1);
clearvars DTW seq1 seq2 
end