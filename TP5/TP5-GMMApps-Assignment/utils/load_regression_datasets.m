function [ X, y_true, y, f] = load_regression_datasets( dataset_type )
dataset_path = '../../TP5-GMMApps-Datasets/';

switch dataset_type
    case '1d-linear'
        nbSamples = 100;
        epsilon   = 5;
        x_limits  = [0, 100];

        % Generate True function and data
        X         = linspace(x_limits(1),x_limits(2),nbSamples);
        y_true    = -0.5*X;
        y         = y_true + normrnd(0,epsilon,1,nbSamples);

        % Center Data and Transpose
        X      = bsxfun(@minus, X, mean(X))';
        y_true = bsxfun(@minus, y_true, mean(y_true))';
        y      = bsxfun(@minus, y, mean(y))';
        
    case '1d-sine'
        
        nbSamples = 75;
        epsilon   = 0.15;
        x_limits  = [0, 100];
        
        % Generate True function and data
        X         = linspace(x_limits(1),x_limits(2),nbSamples);
        y_true    = sin(X*0.05);
        y         = y_true + normrnd(0,epsilon,1,nbSamples);
            
        % Center Data and Transpose
        X      = bsxfun(@minus, X, mean(X))';
        y_true = bsxfun(@minus, y_true, mean(y_true))';
        y      = bsxfun(@minus, y, mean(y))';
        
    case '1d-sinc'
        
        % Set parameters for sinc function data
        nbSamples = 200;
        epsilon   = 0.075;
        x_limits  = [-5, 5];
        
        % Generate True function and data
        X = linspace(x_limits(1),x_limits(2),nbSamples);
        y_true = sinc(X);
        y = y_true + normrnd(0,epsilon,1,nbSamples);
        
        
        % Center Data and Transpose
        X      = bsxfun(@minus, X, mean(X))';
        y_true = bsxfun(@minus, y_true, mean(y_true))';
        y      = bsxfun(@minus, y, mean(y))';
        
    case '2d-cossine'
        
        % Generate a target function to learn from and visualise
        f       = @(X)sin(X(:,1)).*cos(X(:,2));   % Original Function
        r       = @(a,b,M,N)a + (b-a).*rand(M,N); % Range of Inputs
        M       = 1000;                           % Number of Points
        X       = r(-3,1,M,2);                    % Input Data
        
        % Generate Noisy Data from true function
        noise   = 0.15;
        y_true  = f(X);
        y       = y_true + normrnd(0,noise,M,1);

    case '2d-gmm'
        load(strcat(dataset_path,'gmm_dataset.mat'))
                        
        % Generate a target function to learn and visualize
        f = @(X)ml_gmm_pdf(X',gmm_x.Priors,gmm_x.Mu,gmm_x.Sigma );
        
        % Generate Training Data from true function
        noise   = 1e-5; M = length(X);
        y_true  = f(X);
        y       = y_true + normrnd(0,noise,M,1);
end

