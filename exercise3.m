clc;
clear;
close all;
addpath('./exercise1Functions')
addpath('./exercise2Functions')
addpath('./exercise3Functions')

% set a random seed and save it
rng(42, 'twister');
% rng(); % try this to apply a random seed
seed = rng;

% load the iris dataset and store it in two arrays meas and species
load fisheriris
featuresLabel = ["Sepal length","Sepal width","Petal length","Petal width"];

% define some ML models using anonymous functions
models{1} = @(x,y) ClassificationDiscriminant.fit(x, y);
models{2} = @(x,y) ClassificationTree.fit(x, y);
models{3} = @(x,y) ClassificationNaiveBayes.fit(x, y);
models{4} = @(x,y) ClassificationKNN.fit(x, y);
modelNames = ["Discriminant Analysis", "Decision Tree", "Naive Bayes", "K-Nearest Neighbors"];

%% Training on simple test splitting using only two features

axis = [1,2];

% extract the first two features
meas = meas(:,axis);
featuresLabel = featuresLabel(:, axis);

% define some valid sizes for testing
validSizes = 0.1:0.1:0.9;

figure('Name','Classification')
for i=1:length(validSizes)
    % split the dataset in train and test set (use trainTestSplit function)
    [xTrain, yTrain, xTest, yTest] = trainTestSplit(meas, species, validSizes(i), seed);

    % train the first model
    model = models{4}(xTrain, yTrain);
    
    % plot the classification region
    plotClassificationRegion(model, xTrain, yTrain, featuresLabel)
    
    % predict the labels
    predictedLabels = model.predict(xTest);
    
    % compute the accuracy
    accuracy = computeAccuracy(yTest, predictedLabels);
    
    % display the accuracy for the current valid size
    disp(join(['validation size: ' num2str(validSizes(i)) ', accuracy ' num2str(accuracy)]))
    
    % this line will pause your script waiting for one second
    % on the next run of the loop it will update your graphs
    pause(1);
end

% Re-run the script while changing the model in model = models{i}(xTrain, yTrain). 
% Can you comment the results?

% Try again while changing the axis
% Play also with the seed and see if it makes any difference