function [X_train, Y_train, X_test, Y_test] = trainTestSplit(X, Y, validSize, seed)
%trainTestSplit Split a dataset between train and test data

% Re-apply the seed
rng(seed)

% Encode the Y vector (each label corresponding to an int)
Y = grp2idx(Y);

% Calculate the number of elements
nbSamples = size(X, 1);

% ADD CODE HERE: Shuffle both X and Y in the same way
% HINT: look up the function randperm in the documentation and indexing in
% the tips file.
cc = randperm(nbSamples);
X = X(cc,:);
Y = Y(cc,:);% inccase 
% END CODE

% calculate the number of classes
nbClasses = length(unique(Y));

% ADD CODE HERE: Calculate the number of train and test samples from valid_size
% HINT: be careful about the meaning of validSize. It is the ratio of
% samples in the TEST set.
nbTrainSamples = (1-validSize)*nbSamples;
nbTestSamples = validSize*nbSamples;
% END CODE

% Calculate the number of train samples per classes based on their
% repartition on the original data
for i=1:nbClasses
    % ADD CODE HERE: calculate the class repartition in Y
    % HINT: it corresponds to the ratio of elements of the i-th class in
    % the whole dataset. Consider using the function sum over a logical
    % array
    classRepartition = sum((Y==i))/nbSamples;
    % END CODE
    
    % multiply the classRepartition ratio with both number of samples
    nbTrainSamplesPerClass(i) = nbTrainSamples * classRepartition;
    nbTestSamplesPerClass(i) = nbTestSamples * classRepartition;
end

% ADD CODE HERE: Initialize an array with zeros to keep track of the
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
    
    % ADD CODE HERE Add the element in the train set if you have not reached the desired
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

