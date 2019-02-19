function y_est = predict_label(Xtest,labels,models)
nm_test = size(Xtest,2);
y_est_prev = zeros(nm_test,length(labels));
for i =1:nm_test
    for c = 1:length(labels)
        logl = my_gmmLogLik(Xtest(:,i), models(c).Priors, models(c).Mu, models(c).Sigma);
        y_est_prev(i,c) = -logl;
    end
end
[~,y_est]=min(y_est_prev,[],2);
end