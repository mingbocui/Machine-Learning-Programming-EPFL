%%  Test Implementation of Principal Component Analysis (PCA)
%    on 2D Datasets.

%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("~/Repositories/ML_toolbox/")) % TODO CHANGE FOR
%WINDOWS LOCATION

%addpath(genpath("~/Repositories/ML_toolbox/functions"))

addpath("../check_utils_encr")
addpath("../Part1")

clear all;
close all;
clc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Load Picture                            %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dataset Path
dataset_path = '../../TP1-PCA-Dataset/';

% Load 2D Testing Dataset for PCA
img = imread(strcat(dataset_path,'flower.ppm'));

% plot the original image and the compressed one side by side
figure('Name', 'Original and compressed images')
subplot(2,2,1)
img = im2double(img);
imshow(img)
title('Original image')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%        Task 7: Test your compress_image.m function         %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = 50;
% This function compress the image with a given value of components to 
% keep
[cimg, ApList, muList] = compress_image(img,p);

%try
    test_compressimage();
%catch
    %error('Something is wrong with your function')
%end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%        Task 8: Test your compression_rate.m function       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function calculates the compression rate of the image
[cr, cSize] = compression_rate(img, cimg, ApList, muList);

fprintf('Image compressed by %f%%, storage size is %.2fmb\n',cr,cSize)

try
    test_compressionrate();
catch
    error('Something is wrong with your function')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%        Task 9: Test your reconstruct_image.m function      %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = [1, 50, 100];
for i=1:3
    [cimg, ApList, muList] = compress_image(img,p(i));

    % reconstruct the image
    rimg = reconstruct_image(cimg, ApList, muList);
    
    % calculate the compression rate
    [cr, cSize] = compression_rate(img, cimg, ApList, muList);

    subplot(2,2,i+1)
    imshow(rimg)
    title(join(['Reconstructed image with p = ' num2str(p(i))]))
    
    fprintf('p=%d, image compressed by %f%%, storage size is %.2fmb\n',p(i),cr,cSize)
end

try
    test_reconstructimage();
catch
    error('Something is wrong with your function')
end