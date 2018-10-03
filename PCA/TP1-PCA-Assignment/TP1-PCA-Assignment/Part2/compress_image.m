function [cimg, ApList, muList] = compress_image(img, p)
%COMPRESS_IMAGE Compress the image by applying the PCA over each channels 
% independently
%
%   input -----------------------------------------------------------------
%   
%       o img : (N x M x 3), an image of size N x M over RGB channels
%       o p : The number of components to keep during projection 
%
%   output ----------------------------------------------------------------
%
%       o cimg : The compressed image
%       o ApList : The projection matrices for each channels
%       o muList : The mean vector for each channels

% ADD CODE HERE: Initialize cimg, ApList and muList with the correct dimensions
% HINT: Check the output dimension of your PCA. For each of them, consider
% the third dimensions as the number of channels (3 here).
% Use the zero function to initialize it with zeros.
cimg = ;
ApList = ;
muList = ;
% END CODE

% loop through all the RGB channels
for i=1:3
    % ADD CODE HERE: Compute the PCA over each channels indepently then 
    % project it with the given number of components. Do not forget to 
    % store each output in their respective placeholders.
    
    
    
    % END CODE
end
end

