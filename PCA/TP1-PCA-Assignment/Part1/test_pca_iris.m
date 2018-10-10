%%  Test Implementation of Principal Component Analysis (PCA)
%    on Iris Dataset. 

%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("D:/EPFL COURSES\2018-2019_Semester_1/Machine Learning Programming/Exercise/PCA/ML_toolbox-master/")) % TODO CHANGE FOR
%WINDOWS LOCATION

addpath("../check_utils_encr")

clear;
close all;
clc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               Load Iris Dataset                            %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load fisheriris;

% ADD CODE HERE: Store the feature data in a variable X
% HINT: Remember that feature data are stored in the meas array and we want
% to compute  the PCA on the feature, not the samples (meas dimansions are
% 150 samples over 4 features)
X = meas';
% END CODE


% Visualize Dataset
options.title = 'X = Iris dataset';
h0 = ml_plot_data(X',options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                Task 1: compute_pca.m function              %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract Principal Directions and Components
[V, L, Mu] = compute_pca(X);

% Test my_pca.m against ML_toolbox numerically
try
    test_mypca(X, V, L, Mu);
catch
    error('Something is wrong with your function')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  Task 2: project_pca.m                     %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Project Data to Choosen Principal Components
p_components = 2;

[A_p, Y] = project_pca(X, Mu, V, p_components );

% Test project_pca.m against ML_toolbox numerically
try
    test_projectpca(A_p, Y, X, Mu, V, p_components);
catch
    error('Probably a dimensionality mismatch.')
end

% Visualize Projected Data
plot_options             = [];
plot_options.is_eig      = true;
plot_options.class_names = 'Iris flowers';
plot_options.title       = join(['Projected data on ' num2str(p_components) ' principal components']);
h1 = ml_plot_data(Y',plot_options);




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               Test reconstruct_pca.m                   %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Project Data
p_projection = 3;
[A_p, Y] = project_pca(X, Mu, V, p_projection);

% Reconstruct Lossy Data from 1d
[X_hat]  = reconstruct_pca(Y, A_p, Mu);

% Test reconstruct_pca.m against ML_toolbox numerically
try
    test_reconstructpca(X_hat, Y, A_p, Mu);
catch
    error('Probably a dimensionality mismatch.')
end

%% Estimate Reconstruction Error
[e_rec]  = reconstruction_error(X, X_hat);
fprintf('Reconstruction Error with p=%d is %f \n',p_projection ,e_rec);

% Test reconstruct_error.m against ML_toolbox numerically
try
    test_reconstructionerror(e_rec, X, X_hat);
catch
    error('Probably a dimensionality mismatch.')
end

% Visualize Reconstructed Data
options.title       = join(['Xhat : Reconstructed Data with p=', num2str(p_projection)]);
h0 = ml_plot_data(X_hat',options);
axis equal;
