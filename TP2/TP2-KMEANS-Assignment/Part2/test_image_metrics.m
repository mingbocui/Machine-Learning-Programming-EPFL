%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("C:\Program Files\MATLAB\toolbox\ML_toolbox-master"))
addpath("../check_utils_encr")
addpath("../Part1")

clear; 
close all; 
clc;

dataset_path = '../../TP2-KMEANS-Datasets/';
rng(42);
seed = rng;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Load Picture                            %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img = imread(strcat(dataset_path,'tiger_usd.jpg'));
img = im2double(img);
imgSize = size(img);
width = size(img,2);
height = size(img,1);
img_flat = reshape(img,width*height,3)';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      Compress image                        %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the compress image given a certain number of clusters
K = 5; init='random'; type='L2'; MaxIter = 100;
[labels, centroids] = compress_image(img,K,init,type,MaxIter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test my_metrics.m function
% on Mu, labels from my_kmeans
test_mymetrics(img_flat, centroids, labels);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             1) Choosing K test kmeans_eval.m               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% K-means Evaluation Parameters
K_range=1:10; type='L2'; repeats = 3; init = 'random'; MaxIter = 25;

% Evaluate K-means to find the optimal K
[RSS_curve,AIC_curve,BIC_curve] = kmeans_eval(img_flat,K_range,repeats,init,type,MaxIter);

% Plot Metric Curves
if exist('h_metrics','var') && isvalid(h_metrics),  delete(h_metrics); end
h_metrics = figure('Color',[1 1 1]);hold on;
plot(RSS_curve,'--o', 'LineWidth', 1); hold on;
plot(AIC_curve,'--o', 'LineWidth', 1); hold on;
plot(BIC_curve,'--o', 'LineWidth', 1); hold on;
xlabel('K')
legend('RSS', 'AIC', 'BIC')
title('Clustering Evaluation metrics')
grid on
axis tight


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test kmeans_eval.m function with previously defined parameters
test_kmeanseval(img_flat, 1:3, repeats, init, type, MaxIter);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                       Visualization                        %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the original image and the compressed one side by side
Kopt = 7;
figure('Name', 'Original and compressed images')
subplot(1,2,1)
imshow(img)
title('Original image')
[labels, centroids] = compress_image(img,Kopt,init,type,MaxIter);
[rimg] = reconstruct_image(labels,centroids,imgSize);
subplot(1,2,2)
imshow(rimg)
title(join(['Optimal with ' num2str(Kopt) ' clusters']))