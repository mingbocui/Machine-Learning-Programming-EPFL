%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("C:\Program Files\MATLAB\toolbox\ML_toolbox-master"))
addpath(genpath("~/Repositories/ML_toolbox/")) % TODO CHANGE FOR
%WINDOWS LOCATION
addpath(genpath("..\..\..\ML_toolbox-master\ML_toolbox-master\"))

addpath(genpath("../utils"))
addpath(genpath("../check_utils_encr"))

clear; 
close all; 
clc;

dataset = '1D'; % change this to load a different dataset

switch dataset
    case '1D'
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%               1) Load 1D Regression Datasets               %%
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% %%%  (1a) Generate Data from a noisy line %%%%%%
        dataset_type = '1d-sine'; % change here again to load a different 1D dataset
        [ X, y_true, y ] = load_regression_datasets( dataset_type );

    case 'wine'
        %% %%%%%%%%%%%%%%%%%% Load 11-D Wine Quality Dataset  %%%%%%%%%%%%%%%%%%%%%
        % This Wine Dataset uses chemical analysis determine the origin of wines
        % https://archive.ics.uci.edu/ml/datasets/Wine
        raw_data = table2array(ml_load_data('winequality-white.csv','csv'));
        X_raw = raw_data(:,1:11);
        y = raw_data(:,12);
        M = size(X_raw,2);

        % Perform PCA on the data
        [V, L, pca_Mu] = compute_pca(X_raw');

        % Find the number of dimensions to project from the eigen values
        p = 2;

        % Project Data to Choosen Principal Components
        [A_p, X_proj] = project_pca(X_raw', pca_Mu, V, p);

        X = X_proj';
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%        2) Fit a GMM Model to your regressive data       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fit GMM with Optimal parameter
params.cov_type = 'diag';
params.k = 3;
params.max_iter_init = 100;
params.max_iter = 500;
params.d_type = 'L2';
params.init = 'plus';

Xi = [X y]';
% Run MY GMM-EM function, estimates the paramaters by maximizing loglik
[Priors, Mu, Sigma] = my_gmmEM(Xi, params);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    3) Compute Regressive Signal and Variance from GMM     %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute Regressive signal and variance
N = size(X,2); P = size(y,2);
in  = 1:N;       % input dimensions
out = N+1:(N+P); % output dimensions
% commented by cmb
[y_est, var_est] = my_gmr(Priors, Mu, Sigma, X', in, out);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               4) Compute regression metrics                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check regression metrics
test_regression_metrics(y_est,y');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      5) Cross validation (cross_validation_gmr.m)          %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GMM parameters
params.cov_type = 'full';
params.max_iter_init = 50;
params.max_iter = 100;
params.d_type = 'L2';
params.init = 'plus';

% Cross-validation parameters
valid_ratio  = 0.2;    % train/test ratio
k_range   = 1:10;   % range of K to evaluate
F_fold    = 10;     % # of Folds for cv

% Compute F-fold cross-validation
[MSE_F_fold, NMSE_F_fold, R2_F_fold, AIC_F_fold, BIC_F_fold, std_MSE_F_fold, std_NMSE_F_fold, std_R2_F_fold, ...,
    std_AIC_F_fold, std_BIC_F_fold] = cross_validation_gmr(X', y', F_fold, valid_ratio, k_range, params);

%% Plot GMM Model Selection Metrics for F-fold cross-validation with std
figure;
errorbar(k_range',AIC_F_fold(k_range)', std_AIC_F_fold(k_range)','--or','LineWidth',2); hold on;
errorbar(k_range',BIC_F_fold(k_range)', std_BIC_F_fold(k_range)','--ob','LineWidth',2);
grid on
xlabel('Number of K components'); ylabel('AIC/BIC Score')
legend('AIC', 'BIC')

%% Plot Regression Metrics for F-fold cross-validation with std
figure;
[ax,hline1,hline2]=plotyy(k_range',MSE_F_fold(k_range)',[k_range' k_range'],[NMSE_F_fold(k_range)' R2_F_fold(k_range)']);
delete(hline1);
delete(hline2);
hold(ax(1),'on');
errorbar(ax(1),k_range', MSE_F_fold(k_range)', std_MSE_F_fold(k_range)','--o','LineWidth',2,'Color', [0 0.447 0.741]);
hold(ax(2),'on');
errorbar(ax(2),k_range',NMSE_F_fold(k_range)', std_NMSE_F_fold(k_range)','--or','LineWidth',2);
errorbar(ax(2),k_range',R2_F_fold(k_range)', std_R2_F_fold(k_range)','--og','LineWidth',2);
xlabel('Number of K components'); ylabel('Measures')
legend('MSE', 'NMSE', 'Rsquared')
grid on
