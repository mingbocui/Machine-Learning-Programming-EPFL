function X = sample_per_class(models, class, nbPoints)

% dimension = size(models(1).Mu,1)
% X = zeros(nbPoints, dimension);
% nm_per_class = nbPoints/C;
X_sample = [];
priors = cumsum(models(class).Priors);
K = length(models(class).Priors);
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
    X_sample = [X_sample;mvnrnd(models(class).Mu(:,kk),models(class).Sigma(:,:,kk),1)];
end
X = X_sample';

end