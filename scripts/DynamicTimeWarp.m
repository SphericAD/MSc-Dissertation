
function output = DynamicTimeWarp(varargin)
%%Runs the DTW algorithm augmented with the euclidean metric to perform K
%nearest neighbours classification for each test sample in the test set
%using the training data.
tic 
time=0;
%%checks for the number of arguments
if length(varargin)<2
    error('No enough arguments')
end
%if window is not specified then
if length(varargin)==2
    w=nan;
end
%%
test_data=varargin{1};
training_data=varargin{2};

noOftestsamp= length(test_data);
[r, categories]=size(training_data);

%%each entry of the output contain a vector of K nearest neighbours and value of 0 or 1 where 1 denote misclassication
output=cell(noOftestsamp,1);


for samp=1:noOftestsamp
     testSamp=test_data{samp};
     %%extract class and the data seperately 
     class=testSamp{1};
     seq= testSamp{2};
     
     %%keeping record of K nearest neighbours and their distances
     min_dist=ones(11,1)*Inf;
     closest_match =zeros(11,1);
     
     %% Comparing the test sample with the entire training set
    for g=1 :categories
        data=training_data{g};
        for i=1:length(data)
            %extraction of class and sample separately
            trainSamp=data{i};
            trainClass =trainSamp{1};
            seq2= trainSamp{2};
            if (toc>=300)
                %save output at regular interval
                time=time+toc
                [L,host]= unix('hostname');
                filename = strcat('output',host,'.mat');
                save (filename,'output','samp');
                tic
            end
            %% applying DTW+MFCC
             distortion= log(DTW(seq,seq2,w)+1); 
            if distortion<max(min_dist)
                min_dist(min_dist==max(min_dist))=distortion;
                closest_match(min_dist==max(min_dist))= trainClass;
             end
        end
    end
    %% The classifier is a 1 vs rest classifier where correct classifiaction denotes 0
    %and misclassifaction denotes 1
    if closest_match(min_dist==min(min_dist))==class
        entry{1}=0;
    else
        entry{1}=1;
    end
    entry{2}=closest_match;
    output{samp}=entry;
    clear closest_match entry min_dist
end

 [L,host]= unix('hostname');
 filename = strcat('output',host,'.mat');
 save (filename,'output','samp');              




clearvars seq1 seq2
time=time+toc






function distortion = DTW(seq1,seq2,w)
%% DTW algorithm for MFCC + baseline featues
% seq1 now is a r by n matrix and seq2 is an r by m matrix where r denote dimension of each feature vector(frame) 
% and n and m denote the length of the sequences

[r2,n]=size(seq1);
[r2, m]= size(seq2);

if n==1 && m==1
    seq1=seq1';
    seq2=seq2';
    [r2,n]=size(seq1);
    [r2, m]= size(seq2);
end

if ~isnan(w)
w = max(w,abs(n-m));
end

%% Initializing The DTW cost matrix
seq1=[zeros(r2,1) seq1];
seq2=[zeros(r2,1) seq2];
DTW = zeros (n+1,m+1);
for l =2 :m+1
    DTW(1,l)=Inf;
end
for l =2 :n+1
    DTW(l,1)=Inf;
end
DTW(1,1)=0;

%% if no window constraints are specified
if (isnan(w))
   p='yes'
for l=2:n+1
    for j=2:m+1
     %using  normal DTW with warping window
      DTW(l,j)= sum((seq1(:,l)-seq2(:,j)).^2) + min ([DTW(l-1,j),DTW(l-1,j-1),DTW(l,j-1)]);
    end
end
distortion =DTW(n+1,m+1)/(n+m);

%% if window constraints are specified
else
    p='no'
  for l=2:n+1
    for j=max(2,l-w) :min(m+1,l+w+1)
     %using  normal DTW with warping window
      DTW(l,j)= sum((seq1(:,l)-seq2(:,j)).^2) + min ([DTW(l-1,j),DTW(l-1,j-1),DTW(l,j-1)]);
    end
  end  
DTW=DTW(2:end,2:end);
distortion =DTW(find(DTW,1,'last'))/(n+m);
end

clearvars DTW seq1 seq2 

end



end
