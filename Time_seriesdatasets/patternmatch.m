function output = patternmatch(test,train)

%% performs 1 nearest neighbour match after mapping the istance to principal subspace
tic

test_labels=test(:,1);
testData=test(:,2:end);


%% the data is now N by D matrix
train_labels=train(:,1);
trainData=train(:,2:end);



function result=wavedecom(data)
%% performs wavelet decomposition
  [samp ,dim]=size(data);
  %result=zeros(samp,1+ fix(dim/2));
  %result=zeros(samp,1+ dim);
  result=zeros(samp,1+3740);
  result(:,1)=data(:,1);
  for k=1 :samp
    sample= data(k,2:end);
    [C,L] =wavedec(sample,14,'Haar');
    result(k,2:end) = C(1:L(end-3));
    %result(k,2:end)=C(1:dim);
  end
end

function result=fourierdecom(data)
    
[samp ,dim]=size(data);
result=zeros(samp,1+ fix(dim/2));
%result=zeros(samp,1+ dim);
  
result(:,1)=data(:,1);
for k=1 :samp
    sample= data(k,2:end);
    fouriercoeff = abs(fft(sample));
    
    result(k,2:end) = fouriercoeff(1:fix(dim/2));
    %result(k,2:length(fouriercoeff)+1)=fouriercoeff;
end
end
time=toc
tic
%%perform wavelet decomposition: feature extraction
%testData=wavedecom(testData);
%trainData=wavedecom(trainData);

%% perform fourier transfor,
%testData=fourierdecom(testData);
%trainData=fourierdecom(trainData);

time=time+toc;
fingerprintSpace = principalcomponents(trainData);

%% projection to principal subspace
%trainDataR= (fingerprintSpace'* trainData')';
%testDataR= (fingerprintSpace'* testData')';
testDataR=testData;
trainDataR=trainData;

output=zeros(1,length(test_labels));
time=time+toc
tic


function output=dtw(test_sample,train_sample)
    costmatrix = zeros(length(test_sample)+1,length(train_sample)+1);
    for p =2 :length(test_sample)+1
        costmatrix(p,1)=Inf;
    end
    for p =2 :length(train_sample)+1
       costmatrix(1,p)=Inf;
    end
    DTW(1,1)=0;
    for j=2:length(test_sample)
        for k=2:length(train_sample)
            costmatrix(j,k) = (test_sample(j) -train_sample(k))^2 +min([costmatrix(j-1,k),costmatrix(j-1,k-1),costmatrix(j,k-1)]);
        end
    end
    output =costmatrix(length(test_sample)+1,length(train_sample)+1)/(length(test_sample)+length(train_sample));
end

function match= nearest_neighbours(sample,data,train_labels)
%% conducts 1 nearest neigbour search.
    [samp, dim]= size(data);
    nearestN=NaN;
    min_dist=Inf;
    for j=1 :samp
        dist= sum ((sample-data(j,:)).^2);
        %dist= dtw(sample,data(j,:));
        if dist<min_dist
            nearestN = train_labels(j);
            min_dist=dist;
        end
    end
    match =nearestN;
end

time =time+toc
tic
%perform 1 nearest neighbour
for i=1 :length(test_labels)
    if toc>300
        time=time+toc
        tic
    end
    match =nearest_neighbours(testDataR(i,:),trainDataR,train_labels);
    if match ==test_labels(i)
        output(i)=1;
    end
end
% output= DynamicTimeWarping(testDataR(:,2:end),trainDataR(:,2:end),testDataR(:,1),trainDataR(:,1));   



time=time+toc
end
    
    
    
  

