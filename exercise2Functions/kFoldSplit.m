function [xTrain, yTtrain, xTest, yTest] = kFoldSplit(X, Y, k, roundNumber, seed)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% Re-apply the seed
rng(seed)

% Encode the Y vector (each label corresponding to an int)
Y = grp2idx(Y);

% Calculate the number of elements
nbSamples = size(X, 1);

% ADD CODE HERE: Shuffle both X and Y in the same way (3 lines)
% HINT: look up the function randperm



% END CODE

% ADD CODE HERE: calculate the fold size
foldSize =
% END CODE

% ADD CODE HERE: divide X and Y into k-folds
% HINT: look for the function reshape
X =
Y =

% ADD CODE HERE: select the test set corresponding to the roundNumber
% HINT: re-apply the reshape function on the selected fold to obtain the
% correct shape for xTest and yTest
xTest = 
yTest =
% END CODE

% ADD CODE HERE: take the rest as train set
% HINT: first select everything except the roundNumber fold
X = 
Y =
% HINT: then re-apply the reshape function to obtain the
% correct shape for xTrain and yTrain
xTrain =
yTtrain =

end

