%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("C:\Program Files\MATLAB\toolbox\ML_toolbox-master"))
addpath(genpath("~/Repositories/ML_toolbox/")) % TODO CHANGE FOR
%WINDOWS LOCATION
addpath(genpath("..\..\..\ML_toolbox-master\ML_toolbox-master\"))
addpath("../check_utils_encr")
addpath("../utils")
addpath("../Part1")

clear; 
close all; 
clc;

dataset_path = '../../TP4-GMM-Datasets/';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         1) Load 2D GMM Fit Function Testing Dataset        %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% choose a dataset
dataset_list = {'1a', '1b', '1c'};
dataset = dataset_list{2};

switch dataset
    %% 1a) Load 2d GMM Dataset
    case '1a'
        if exist('X'); clear X; end
        if exist('labels'); clear labels;end
        load(strcat(dataset_path,'/2D-GMM.mat'))
        % Visualize Dataset
        options.labels      = labels;
        options.class_names = {};
        options.title       = '2D GMM Dataset';
        if exist('h0','var') && isvalid(h0), delete(h0);end
        h0 = ml_plot_data(X',options);hold on;
        colors     = hsv(4);
        ml_plot_centroid(gmm.Mu',colors);hold on; 
        plot_gmm_contour(gca,gmm.Priors,gmm.Mu,gmm.Sigma,colors);
        grid on; box on;
        
    %% 1b) Load 2d Circle Dataset
    case '1b'
        if exist('X'); clear X; end
        if exist('labels'); clear labels;end
        load(strcat(dataset_path,'/2d-concentric-circles.mat'))
        % Visualize Dataset
        options.class_names = {};
        options.title       = '2D Concentric Circles Dataset';
        options.labels       = y;
        if exist('h0','var') && isvalid(h0), delete(h0);end
        h0 = ml_plot_data(X',options);hold on;


    %% 1c) Draw Data with ML_toolbox GUI
    case '1c'
        close all; clc;
        if exist('X'); clear X; end
        if exist('labels'); clear labels;end
        [X, labels] = ml_draw_data();
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             2) Check gmm_metrics.m function                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test gmm_metrics.m implementation
test_gmmMetrics(X);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%              3) Choosing K test gmm_eval.m                 %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test gmm_eval.m implementation
test_gmmeval(X);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% K-means Evaluation Parameters
K_range = 1:10; 
repeats = 10;
%% Set GMM Hyper-parameters
params.cov_type = 'full';
params.k = 4;
params.max_iter_init = 100;
params.max_iter = 500;
params.d_type = 'L2';
params.init = 'plus';

% Evaluate gmm-em to find the optimal k
[AIC_curve, BIC_curve] = gmm_eval(X, K_range, repeats, params);

% Plot Metric Curves
figure('Color',[1 1 1]);
plot(AIC_curve,'--o', 'LineWidth', 1); hold on;
plot(BIC_curve,'--o', 'LineWidth', 1); hold on;
xlabel('K')
legend('AIC', 'BIC')
title(sprintf('GMM (%s) Model Fitting Evaluation metrics',params.cov_type))
grid on

%% Pick best K from Plot and Visualize result
% Set GMM Hyper-parameters 
params.k = 3;
%%%% Run MY GMM-EM function, estimates the paramaters by maximizing loglik
[Priors, Mu, Sigma, iter] = my_gmmEM(X, params);

%%%%%% Visualize Final Estimates %%%%%%
options.labels      = [];
options.class_names = {};
options.plot_figure = false;
if exist('h1','var') && isvalid(h1), delete(h1);end
h1 = ml_plot_data(X',options);hold on;
colors     = hsv(params.k);
ml_plot_centroid(Mu',colors);hold on;
plot_gmm_contour(gca,Priors,Mu,Sigma,colors);
title(sprintf('Final GMM Parameters iter= %d',iter));
grid on; box on;

% Visualize GMM pdf from learnt parameters
ml_plot_gmm_pdf(X, Priors, Mu, Sigma)
