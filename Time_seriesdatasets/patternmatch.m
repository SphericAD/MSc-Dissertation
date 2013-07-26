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
  result=zeros(samp,1+ fix(dim/2));
  %result=zeros(samp,1+ dim);
  
  result(:,1)=data(:,1);
  for k=1 :samp
    sample= data(k,2:end);
    [C,L] =wavedec(sample,13,'Haar');
    result(k,2:end) = C(1:L(end-1));
    %result(k,2:end)=C(1:dim);
  end
end

function result=fourierdecom(data)
    
[samp ,dim]=size(data);
%result=zeros(samp,1+ fix(dim/2));
result=zeros(samp,1+ dim);
  
result(:,1)=data(:,1);
for k=1 :samp
    sample= data(k,2:end);
    fouriercoeff = abs(fft(sample));
    
    %result(k,2:end) = fouriercoeff(1:fix(dim/2));
    result(k,2:length(fouriercoeff)+1)=fouriercoeff;
end
end
time=toc
tic
%%perform wavelet decomposition: feature extraction
%testData=wavedecom(testData);
%trainData=wavedecom(trainData);

%% perform fourier transfor,
testData=fourierdecom(testData);
trainData=fourierdecom(trainData);

time=time+toc;
fingerprintSpace = principalcomponents(trainData);

tic
%% projection to principal subspace
trainDataR= (fingerprintSpace'* trainData')';
testDataR= (fingerprintSpace'* testData')';
output=zeros(1,length(test_labels));
time=time+toc
tic


function match= nearest_neighbours(sample,data,train_labels)
%% conducts 1 nearest neigbour search.
    [samp, dim]= size(data);
    nearestN=NaN;
    min_dist=Inf;
    for j=1 :samp
        dist= sum ((sample-data(j,:)).^2);
        if dist<min_dist
            nearestN = train_labels(j);
            min_dist=dist;
        end
    end
    match =nearestN;
end

time =time+toc
tic
%%perform 1 nearest neighbour
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


toc
end
    
    
    
  

