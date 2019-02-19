function [MSE, NMSE, Rsquared] = my_regression_metrics( yest, y )
%MY_REGRESSION_METRICS Computes the metrics (MSE, NMSE, R squared) for 
%   regression evaluation
%
%   input -----------------------------------------------------------------
%   
%       o yest  : (P x M), representing the estimated outputs of P-dimension
%       of the regressor corresponding to the M points of the dataset
%       o y     : (P x M), representing the M continuous labels of the M 
%       points. Each label has P dimensions.
%
%   output ----------------------------------------------------------------
%
%       o MSE       : (1 x 1), Mean Squared Error
%       o NMSE      : (1 x 1), Normalized Mean Squared Error
%       o R squared : (1 x 1), Coefficent of determination
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auxiliary Variables
[~, M] = size(y);
% MSE = (1./M)*sum(sum((yest-y).^2));
MSE = (1./M)*sum(sum((yest-y).^2));

mu_y = (1/M)*sum(y,2);
var_y = (1/(M-1))*sum(sum((y-repmat(mu_y,1,M)).^2));
NMSE = MSE / var_y;
mu_y_t = (1/M)*sum(yest,2);

sum_y_yest = sum((sum((y-repmat(mu_y,1,M)).*(yest-repmat(mu_y_t,1,M)),2)).^2);
sum_y = sum(sum((y-repmat(mu_y,1,M)).^2));
sum_y_t = sum(sum((yest-repmat(mu_y_t,1,M)).^2));
Rsquared = sum_y_yest/(sum_y*sum_y_t);



end

