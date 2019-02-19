%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("C:\Program Files\MATLAB\toolbox\ML_toolbox-master"))
addpath("../check_utils_encr")

clear; 
close all; 
clc;

dataset_path = '../../TP2-KMEANS-Datasets/';
rng(42);
seed = rng;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Load Picture                            %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img = imread(strcat(dataset_path,'tiger_sd.jpg'));
img = im2double(img);
imgSize = size(img);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%              1) Test compress_image.m function             %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the compress image given a certain number of clusters
K = 5; init='random'; type='L2'; MaxIter = 100;
[labels, centroids] = compress_image(img,K,init,type,MaxIter);

% check results
test_compression();

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%              2) Test reconstruct_image.m function          %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rimg] = reconstruct_image(labels,centroids,imgSize);

% check results
test_reconstruction();

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  Visualize compressed images               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K_range=2:6;
% plot the original image and the compressed one side by side
figure('Name', 'Original and compressed images')
subplot(3,2,1)
imshow(img)
title('Original image')
for i=1:size(K_range,2)
    K = K_range(i);
    [labels, centroids] = compress_image(img,K,init,type,MaxIter);
    [rimg] = reconstruct_image(labels,centroids,imgSize);
    subplot(3,2,i+1)
    imshow(rimg)
    title(join([num2str(K) ' clusters']))
end