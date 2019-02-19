%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("C:\Program Files\MATLAB\toolbox\ML_toolbox-master"))
% addpath(genpath("~/Repositories/ML_toolbox/")) % TODO CHANGE FOR
%WINDOWS LOCATION
addpath("../check_utils_encr")
addpath("../utils")

addpath(genpath("..\..\..\ML_toolbox-master\ML_toolbox-master\"))


clear; 
close all; 
clc;

dataset_path = '../../TP4-GMM-Datasets/';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         1) Load 2D GMM-EM Function Testing Dataset          %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% choose a dataset
dataset_list = {'1a', '1b', '1c'};
dataset = dataset_list{1};

switch dataset
    %% (1a) Load 2D data for testing Gausspdf and Covariance Matrices
    case '1a'
        if exist('X'); clear X; end
        if exist('labels'); clear labels;end
        load(strcat(dataset_path,'/2D-Gaussian.mat'));
        % Visualize Dataset
        options.class_names = {};
        options.title       = '2D Gaussian Dataset';
        if exist('h0','var') && isvalid(h0), delete(h0);end
        h0 = ml_plot_data(X',options);hold on;
        
     %% (1b) Load 2D dataset for testing GMM-EM & Likelihood
    case '1b'
        if exist('X'); clear X; end
        if exist('labels'); clear labels;end
        load(strcat(dataset_path,'/2D-GMM.mat'));
        % Visualize Dataset
        options.labels      = labels;
        options.class_names = {};
        options.title       = '2D GMM Dataset';
        if exist('h0','var') && isvalid(h0), delete(h0);end
        h0 = ml_plot_data(X',options);hold on;
        colors     = hsv(4);
        ml_plot_centroid(gmm.Mu',colors);hold on; 
        plot_gmm_contour(gca,gmm.Priors,gmm.Mu,gmm.Sigma,colors,0.5);
        grid on; box on;

    %% 1c) Draw Data with ML_toolbox GUI
    case '1c'
        close all; clc;
        if exist('X'); clear X; end
        if exist('labels'); clear labels;end
        [X, labels] = ml_draw_data();
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%              2) Test my_gaussPDF.m function                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch dataset
    case '1a' % Real Mu and Sigma used for 1a
        Mu = [1;1];
        Sigma = [1, 0.5; 0.5, 1];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Test my_gaussPDF.m implementation
        test_mygaussPDF(X, Mu, Sigma);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             3) Test my_gmmloglik.m function               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch dataset
    case '1a' % Real Mu and Sigma used for 1a
        Mu = [1;1];
        Sigma = [1, 0.5; 0.5, 1];
        Priors = [1];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Test my_gmmLogLik.m implementation
        test_mygmmLogLik(X, Priors, Mu, Sigma);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case '1b' % Load gmm parameters with real values        
        Priors = gmm.Priors;
        Mu     = gmm.Mu;
        Sigma  = gmm.Sigma;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Test my_gmmLogLik.m implementation
        test_mygmmLogLik(X, Priors, Mu, Sigma);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            4) Test my_covariance.m function               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test my_covariance.m implementation
test_mycovariance(X); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Visualize different covariance matrices %%%%
[Sigma_full, Sigma_diag, Sigma_iso] = visualize_covariances(X);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          5) Test my_gmmInit.m function         %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test my_gmmInit.m implementation
test_mygmmInit(X);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set GMM Hyper-parameters
params.cov_type = 'full';
params.k = 4;
params.max_iter_init = 100;
params.d_type = 'L2';
params.init = 'plus';

% Run GMM-INIT function, estimates and visualizes initial parameters for EM algorithm
[ Priors0, Mu0, Sigma0, labels0 ] = my_gmmInit(X, params);

%%%%%% Visualize Initial Estimates %%%%%%
options.labels      = labels0;
options.class_names = [];
options.title       = 'Initial Estimates for EM-GMM';
if exist('h0','var') && isvalid(h0), delete(h0);end
h0 = ml_plot_data(X',options);hold on;
colors     = hsv(params.k);
ml_plot_centroid(Mu0',colors);hold on;
plot_gmm_contour(gca,Priors0,Mu0,Sigma0,colors);
grid on; box on;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           6) Test my_gmmEM.m function          %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set GMM Hyper-parameters
params.cov_type = 'full';
params.k = 4;
params.max_iter_init = 100;
params.max_iter = 500;
params.d_type = 'L2';
params.init = 'plus';

%%%%%% Visualize Initial Estimates %%%%%%
options.labels      = [];
options.class_names = [];
options.title       = 'Initial Estimates for EM-GMM';
if exist('h0','var') && isvalid(h0), delete(h0);end
h0 = ml_plot_data(X',options);hold on;
colors     = hsv(params.k);
ml_plot_centroid(Mu0',colors);hold on;
plot_gmm_contour(gca,Priors0,Mu0,Sigma0,colors);
grid on; box on;

%%%% Run MY GMM-EM function, estimates the paramaters by maximizing loglik
tic;
[Priors, Mu, Sigma, iter] = my_gmmEM(X, params);
toc;

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

%% Visualize GMM pdf from learnt parameters
ml_plot_gmm_pdf(X, Priors, Mu, Sigma); hold on;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test my_gmmEM.m implementation
pts = test_mygmmEM(X);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
