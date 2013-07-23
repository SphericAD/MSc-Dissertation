function data = createdatamatrix(data)

%% takes the raw  training data set that is partioned into categories and classes  and creates a data matrix.
% output : datamatrix where the first column holds information about the
% classes




%%  extracts data of each category
boy =data{1};
girl=data{2};
men=data{3};
women=data{4};



%% find the maximum length of the sequences.
maximum_length=-Inf;




%% counter keeps track of the total size of the training set
  count=1;
 labels={};

function findmaxlength(cg_data)
%% records the maximum length of the sequence seen in the data so far

    [categories, classes, production] =size(cg_data);
    for c=1 : categories
        for  i=1 : classes
            labels{count} =i;
            count=count+1;
            seqlen= length(cg_data{c,i,1});
            if seqlen>maximum_length
                maximum_length= seqlen;
            end
        end
    end
end
tic
findmaxlength(boy);
toc
tic
findmaxlength(girl);
toc
tic
findmaxlength(men);
toc
tic

findmaxlength(women);
toc
%% creates the data matrix
data= zeros ( count-1, maximum_length+1);
data(:,1)= cell2mat(labels);% 1st column contains label information

counter=1;
fillmatrix(boy);
fillmatrix(girl);
fillmatrix(men);
fillmatrix(women);


function fillmatrix(cg_data)
  
%% fills in the matrix after resampling     
    [categories, classes, production] =size(cg_data);
    for c=1:categories 
         for i=1:classes
             sample=cg_data{c,i,1};
             data(counter,2:end)= resample(sample,maximum_length,length(sample));
             counter=counter+1;
         end
    end
end
tic
fillmatrix(boy);
toc
tic
toc
fillmatrix(girl);
tic
fillmatrix(men);
toc
tic
fillmatrix(women);
end
