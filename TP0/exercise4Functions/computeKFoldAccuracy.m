function [modelAccuracy] = computeKFoldAccuracy(models, modelIndex, X, Y, nbFolds, seed)
%COMPUTEKFOLDACCURACY Summary of this function goes here
%   Detailed explanation goes here

% loop through all the folds
for iter=1:nbFolds
    % divide the dataset in k fold and set the i-th fold as test set
    % HINT: make use of the kFoldSplit function
    [xTrain, yTrain, xTest, yTest] = kFoldSplit(X,Y,nbFolds,iter,seed)
    
    % END CODE
    
    % train the model on the train folds
    model = models{modelIndex}(xTrain, yTrain);
    
     % predict the labels based on test set data
    predictedLabels = model.predict(xTest);
    
    % ADD CODE HERE: compute the accuracy
    % HINT: you can use the function defined in exercice 3
    modelAccuracy(iter) = computeAccuracy(yTest,predictedLabels);
    % END CODE HERE
end

% ADD CODE HERE: compute the mean of the accuracies of each fold

modelAccuracy = sum(modelAccuracy)/size(modelAccuracy,1);

% END CODE
end

