function models = model_train(Xtrain, Ytrain, params)
models = [struct()];
for c = 1:length(unique(Ytrain))
    [Priors, Mu, Sigma, iter] = my_gmmEM(Xtrain(:,Ytrain==c), params);
    models(c).Priors = Priors;
    models(c).Mu = Mu;
    models(c).Sigma = Sigma;
end
end
