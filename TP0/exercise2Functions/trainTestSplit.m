function [X_train, Y_train, X_test, Y_test] = trainTestSplit(X, Y, validSize, seed)
%trainTestSplit Split a dataset between train and test data

% Re-apply the seed
rng(seed)

% Encode the Y vector (each label corresponding to an int)
Y = grp2idx(Y);

% Calculate the number of elements
nbSamples = size(X, 1);

rand_perm = randperm(nbSamples);
X = X(rand_perm,:);
Y = Y(rand_perm,:);% incase Y has more columns

% calculate the number of classes, unique function returns different
% classifications
nbClasses = length(unique(Y));

%Calculate the number of train and test samples from valid_size
nbTrainSamples = (1-validSize)*nbSamples;
nbTestSamples = validSize*nbSamples;

% Calculate the number of train samples per classes based on their
% repartition on the original data
for i=1:nbClasses
    % calculate the class repartition in Y
    classRepartition = sum((Y==i))/nbSamples;
   
    % multiply the classRepartition ratio with both number of samples
    nbTrainSamplesPerClass(i) = nbTrainSamples * classRepartition;
    nbTestSamplesPerClass(i) = nbTestSamples * classRepartition;
end

% Initialize an array with zeros to keep track of the
% current number of samples per class
currentTrainSamplesPerClass = zeros(nbClasses, 1);
currentTestSamplesPerClass = zeros(nbClasses, 1);

% Initialize all returned arrays to empty vectors
X_train = [];
Y_train = [];
X_test = [];
Y_test = [];

% Split the dataset between train and test set
for i=1:nbSamples
    % Get the class of the sample
    class = Y(i);
    
    % Add the element in the train set if you have not reached the desired
    % number of train or test sample for this class
    if(currentTrainSamplesPerClass(class) < nbTrainSamplesPerClass(class))
        X_train = [X_train; X(i,:)];
        Y_train = [Y_train; Y(i,:)];
        currentTrainSamplesPerClass(class) = currentTrainSamplesPerClass(class) + 1; 
    elseif(currentTestSamplesPerClass(class) < nbTestSamplesPerClass(class))
        X_test = [X_test; X(i,:)];
        Y_test = [Y_test; Y(i,:)];
        currentTestSamplesPerClass(class) = currentTestSamplesPerClass(class) + 1;
    end
    % END CODE
end

