clc;
clear;
close all;
addpath('./exercise1Functions')
addpath('./exercise2Functions')

%% Split a dataset between training and validation sets

% load the iris dataset and store it in two arrays meas and species
load fisheriris
featuresLabel = {'Sepal length','Sepal width','Petal length','Petal width'};

% pourcentage of samples that will be used for validation
validSize = 0.2;

% set a random seed and save it
rng(42, 'twister');
seed = rng;

% split the dataset in train and test set (use trainTestSplit function)
[xTrain, yTrain, xTest, yTest] = trainTestSplit(meas, species, validSize, seed);

% verify your results using assert functions
assert(size(xTrain, 2) == size(meas, 2))
assert(size(xTrain, 1) == size(yTrain, 1))
assert(size(xTrain, 1) == size(meas, 1) * (1-validSize))
assert(size(xTest, 1) == size(yTest, 1))
assert(size(xTest, 1) == size(meas, 1) * validSize)

% best possible tests
assert(isequal(sort([xTrain; xTest]), sort(meas)))
assert(isequal(sort([yTrain; yTest]), sort(grp2idx(species))))

figure('Name', 'Train and test dataset')
% plot each sample of the three species for the full dataset
subplot(3,1,1)
plot2DSamples(meas, species, featuresLabel, [1,2]);
title('Full dataset')

% plot each sample of the three species for the train dataset
subplot(3,1,2)
plot2DSamples(xTrain, yTrain, featuresLabel, [1,2]);
title('Train dataset')

% plot each sample of the three species for the test dataset
subplot(3,1,3)
plot2DSamples(xTest, yTest, featuresLabel, [1,2]);
title('Test dataset')

%% K-fold cross validation splitting

% set the number of folds 
k=10;

figure('Name', 'K-fold cross validation dataset')
xFold = [];
yFold = [];
for i=1:k
    subplot(2, k/2, i)
    % divide the dataset in k fold and set the i-th fold as test set 
    [xTrain, yTrain, xTest, yTest] = kFoldSplit(meas, species, k, i, seed);
    plot2DSamples(xTest, yTest, featuresLabel, [1,2]);
    title(['Test set ' num2str(i)])
    % append all the test sets to get back the original data
    xFold = [xFold; xTest];
    yFold = [yFold; yTest];
end

% verify your results
assert(isequal(sort(xFold), sort(meas)))
assert(isequal(sort(yFold), sort(grp2idx(species))))







