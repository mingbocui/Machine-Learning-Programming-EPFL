clc;
clear;
close all;
addpath('./exercise1Functions')
addpath('./exercise2Functions')
addpath('./exercise3Functions')
addpath('./exercise4Functions')

% set a random seed and save it
rng(42, 'twister');
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

axis = [1,2];
% extract the features in axis
meas = meas(:,axis);
featuresLabel = featuresLabel(:, axis);

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
assert(isequal(sort(xFold), sort(meas)));
assert(isequal(sort(yFold), sort(grp2idx(species))));

% Re-run the script with different values of k and observe the results.
% Be careful that some values of k might break your splitting

%% Model selection on simple test splitting

disp('Training on train test split');
% pourcentage of samples that will be used for validation
validSize = 0.2;

% split the dataset in train and test set (use trainTestSplit function)
[xTrain, yTrain, xTest, yTest] = trainTestSplit(meas, species, validSize, seed);

% test all of them on the splitted dataset
for i=1:4
    % train the model
    model = models{i}(xTrain, yTrain);
    
    % predict the labels based on test set data
    predictedLabels = model.predict(xTest);
    
    % compute the accuracy
    accuracy = computeAccuracy(yTest, predictedLabels);
    
    % display the accuracy for the current model
    disp(join([modelNames(i) ': ' num2str(accuracy)]))
end

fprintf('\n')
% Run the script multiple times while changing the seed and observe the results
% You can also change the axis to include more or less features
% What do you think is the best model?

%% Model selection on K-fold splitting
 
disp('Training on k-fold cross validation');
% define the number of folds
k = 5;
 
% test all models on k-fold cross validation
for i=1:4
    % compute the accuracy
    accuracy = computeKFoldAccuracy(models, i, meas, species, k, seed);
     
    % display the accuracy for the current model
    disp(join([modelNames(i) ': ' num2str(accuracy)]))
end
 
fprintf('\n')
% Run the script multiple times while changing the seed and observe the results
% You can also change the axis to include more or less features
% Can you now select the best model for this dataset?