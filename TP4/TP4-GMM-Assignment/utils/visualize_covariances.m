function [Sigma_full, Sigma_diag, Sigma_iso ] = visualize_covariances( X )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

% Mean of Dataset
Mu = mean(X,2); 

close all
% Compute Full Cov. matrix and plot contours on data
type = 'full';
Sigma = my_covariance( X, Mu, type );
if exist('h_full','var') && isvalid(h_full), delete(h_full);end
options.title        = 'Full Covariance Matrix';
h_full = ml_plot_data(X',options); hold on;
ml_plot_centroid(Mu',[1 0 0]); hold on; 
plot_gmm_contour(gca,1,Mu,Sigma,[1 0 0]);
Sigma_full = Sigma;
axis equal

% Compute Diagonal Cov. matrix and plot contours on data
type = 'diag';
Sigma = my_covariance( X, Mu, type );
if exist('h_diag','var') && isvalid(h_diag), delete(h_diag);end
options.title       ='Diagonal Covariance Matrix';
h_diag = ml_plot_data(X',options); hold on;
ml_plot_centroid(Mu',[0 1 0]); hold on; 
plot_gmm_contour(gca,1,Mu,Sigma,[0 1 0]);
Sigma_diag = Sigma;
axis equal

% Compute Isotropic Cov. matrix and plot contours on data
type = 'iso';
Sigma = my_covariance( X, Mu, type );
if exist('h_iso','var') && isvalid(h_iso), delete(h_iso);end
options.title       = 'Isotropic Covariance Matrix';
h_iso = ml_plot_data(X',options); hold on;
ml_plot_centroid(Mu',[0 0 1]); hold on; 
plot_gmm_contour(gca,1,Mu,Sigma,[0 0 1]); 
Sigma_iso = Sigma;
axis equal
end

