function [rimg] = reconstruct_image(labels,centroids,imgSize)
%RECONSTRUCT_IMAGE Reconstruct the image given the labels and the centroids
%
%   input -----------------------------------------------------------------
%   
%       o labels: The labels of the corresponding centroid for each pixel
%       o centroids: All the centroids and their RGB color value
%       o imgSize: Size of the original image for reconstruction
%
%   output ----------------------------------------------------------------
%
%       o rimg : The reconstructed image

% ADD CODE HERE: Reconstruct the image based on the labels on the centroids
% HINT: Apply the two steps you have used to reshape in the opposite order 
% if necessary

rimg1 = reshape(zeros(imgSize),3,[]);
for i=1:size(labels,2)
    rimg1(:,i) = centroids(:,labels(i));
end
rimg1r = reshape(rimg1(1,:),imgSize(1),imgSize(2));
rimg2r = reshape(rimg1(2,:),imgSize(1),imgSize(2));
rimg3r = reshape(rimg1(3,:),imgSize(1),imgSize(2));
all=[rimg1r,rimg2r,rimg3r];
rimg = reshape(all,imgSize(1),imgSize(2),imgSize(3));
    






% END CODE
end
