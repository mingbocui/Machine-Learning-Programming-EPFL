function X_sample = sample_model(c,models,nbPoints)


X_sample = [];
priors = cumsum(models(c).Priors);
K = length(models(c).Priors);
for i =1:nbPoints
    probability = rand();
    kk = 0;
    if(probability < priors(1))
            kk = 1;
    end
    for k =2:K
        if(probability > priors(k-1) && probability < priors(k))
            kk = k;
        end
    end
    X_sample = [X_sample;mvnrnd(models(c).Mu(:,kk),models(c).Sigma(:,:,kk),1)];
end
X_sample = X_sample';

end