function [X_train, Y_train, X_test, Y_test] = trainTestSplit(X, Y, validSize, seed)
%trainTestSplit Split a dataset between train and test data

% Re-apply the seed
rng(seed)

% Encode the Y vector (each label corresponding to an int)
Y = grp2idx(Y);

% Calculate the number of elements
nbSamples = size(X, 1);

% ADD CODE HERE: Shuffle both X and Y in the same way (3 lines)
% HINT: look up the function randperm



% END CODE

% calculate the number of classes
nbClasses = length(unique(Y));

% Calculate the number of train and test samples from valid_size
nbTrainSamples = nbSamples * (1 - validSize);
nbTestSamples = nbSamples - nbTrainSamples;

% Calculate the number of train samples per classes based on their
% repartition on the original data
for i=1:nbClasses
    % ADD CODE HERE: calculate the class repartition in Y
    % HINT: for the iris dataset classRepartition(i) = 1/3. Use that value
    % to check your formula
    classRepartition =
    nbTrainSamplesPerClass(i) =
    nbTestSamplesPerClass(i) =
    % END CODE
end

% Initialize an array to keep track of the current number of samples per
% class
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
    
    % ADD CODE HERE
    % Add the element in the train set if you have not reached the desired
    % number of train sample for this class yet
    
    
    
    % Add the element in the test set if you have not reached the desired
    % number of train sample for this class yet
    
    
    
    % END CODE
    end
end

