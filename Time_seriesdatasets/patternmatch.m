function output = patternmatch(test,train)

%% performs 1 nearest neighbour match after mapping the instance to latent factors using a 4 step feature extraction phase.


tic

test_labels=test(:,1);
testData=test(:,2:end);


%% the data is now N by D matrix
train_labels=train(:,1);
trainData=train(:,2:end);



function result=wavedecom(data)
  %% performs wavelet decomposition 
  [samp ,dim]=size(data);
  result=zeros(samp,1+ fix(dim/32));
  %result=zeros(samp,1+52);
 
  for k=1 :samp
    sample= data(k,:);
    %%for speech data extract envelope
    y= abs(hilbert(sample(sample>0)));
    y1= abs(hilbert(sample(sample<=0)));
    envelope=[y -1*y1];
    
    [C,L] =wavedec(envelope,8,'Haar');
    signal= C(1:L(1));
    figure(4)
    subplot(4,1,1)
    plot(sample)
    subplot(4,1,2)
    plot(envelope)
    subplot(4,1,3)
    plot(signal)
    subplot(4,1,4)
    
    %result(k,1:L(1))=C(1:L(1));
    result(k,1:L(1)) = compute_curvature([1:L(1)],signal);
    %result(k,2:end)=C(1:dim);
  end
end

function result=fourierdecom(data)
    
[samp ,dim]=size(data);
result=zeros(samp, fix(77));
%result=zeros(samp,1+ dim);
  
%result(:,1)=data(:,1);
for k=1 :samp
    sample= data(k,:);
    fouriercoeff = abs(fft(sample));
    
    result(k,:) = fouriercoeff(1:77);
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
DATA=[trainData;testData];
fingerprintSpace = principalcomponents(DATA);

%% projection to principal subspace
trainDataR= (fingerprintSpace'* trainData')';
testDataR= (fingerprintSpace'* testData')';
testDataR=testData;
trainDataR=trainData;

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
    
    
    
  

