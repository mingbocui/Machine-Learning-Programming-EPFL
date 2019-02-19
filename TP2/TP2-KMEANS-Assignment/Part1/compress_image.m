function [labels, centroids] = compress_image(img,K,init,type,MaxIter)
%COMPRESS_IMAGE Compress the image using k-means
%
%   input -----------------------------------------------------------------
%   
%       o img      : (height x width x 3), the image to cluster
%       o K        : (int), chosen K clusters
%       o init     : (string), type of initialization {'random','uniform'}
%       o type     : (string), type of distance {'L1','L2','LInf'}
%       o MaxIter  : (int), maximum number of iterations

%
%   output ----------------------------------------------------------------
%
%       o labels    : (1 x M), a vector with predicted labels labels \in {1,..,k} 
%                   corresponding to the k-clusters.
%       o centroids : (3 x k), centroid of the clusters (corresponds to Mu
%                     returned by k-means


% ADD CODE HERE
% HINT: reshape the img data to get 3x(width*height) array prior to call 
% k-means. Be carefull about the way reshaping works
img_reshape1 = reshape(img(:,:,1),1,[]);
img_reshape2 = reshape(img(:,:,2),1,[]);
img_reshape3 = reshape(img(:,:,3),1,[]);
img_reshape = [img_reshape1;img_reshape2;img_reshape3];
[labels, centroids, ~, ~] =  my_kmeans(img_reshape,K,init,type,MaxIter,0);



% END CODE
end

