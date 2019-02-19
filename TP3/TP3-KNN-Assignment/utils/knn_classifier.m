function [labels, model] = knn_classifier(X, labels, model, knn_options)
%KNN_CLASSIFIER  Wrapping function for my_knn to plot decision boundary
%
%   input ----------------------------------------------------------------
%
%       o   X       : (N x D), number of datapoints.
%
%       o labels    : (N x 1), number of class labels 
%
%       o model     : struct, result of trained  classifier with
%                             all parameters, etc..
%

% if the model exists, evaluate the classifier else train it
if isempty(model) % TRAIN (In KNN theres is no training so just create the model object)
    %                        (mode,X,labels,model,itt)    
            model.X_train = X;
            model.y_train = labels;
            model.k       = knn_options.k;
            model.d_type  = knn_options.d_type;
else
    
            labels     = my_knn(model.X_train, model.y_train, X, model);
    
end