function [X_train, Y_train, X_test, Y_test] = kFoldSplit(X, Y, k, roundNumber, seed)

rng(seed)
% Encode the Y vector (each label corresponding to an int)
Y = grp2idx(Y);

% Calculate the number of elements
nbSamples = size(X, 1);

%shuffle X and Y in as in trainTestSplit
rand_perm = randperm(nbSamples);
X = X(rand_perm,:);
Y = Y(rand_perm,:);

% calculate the fold size from the value of k
foldSize = nbSamples/k;

% divide X and Y into k folds
% HINT: you can use the function reshape as k will be a dividor of your
% total number of samples
X = reshape(X,k,foldSize,size(X,2));
Y = reshape(Y,k,foldSize,size(Y,2));
% END CODE

% ADD CODE HERE: select the test set corresponding to the roundNumber
% HINT: roundNumber coressponds to the index of your test set. Do not
% forget to reshape again your to have only a 2d array
X_test = reshape(X(roundNumber,:,:),foldSize,size(X,3));
Y_test = reshape(Y(roundNumber,:,:),foldSize,size(Y,3));
% END TEST

% take the rest as train set
% HINT: you can start by removing the fold that serves as test set. 
% Again do not forget to reshape
X = X([1:roundNumber-1,roundNumber+1:end],:,:);
Y = Y([1:roundNumber-1,roundNumber+1:end],:,:);
X_train = reshape(X,nbSamples-foldSize,size(X,3));
Y_train = reshape(Y,nbSamples-foldSize,size(Y,3));
% END CODE

end

