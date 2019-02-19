function X = sample_multi_class(models,nbPoints)

C = 1:size(models.Priors,2);%get the number of clusters
k = randsrc(nbPoints,1,[C;models.Priors]);
X_sample = zeros(size(models.Mu,1),nbPoints);
for i=1:nbPoints
    X_sample(:,i) = mvnrnd(models.Mu(:,k(i)),models.Sigma(:,:,k(i)));
end
X = X_sample;
end