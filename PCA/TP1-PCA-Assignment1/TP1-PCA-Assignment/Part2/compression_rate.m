function [cr, compressedSize] = compression_rate(img,cimg,ApList,muList)
%COMPRESSION_RATE Calculate the compression rate based on the original
%image and all the necessary components to reconstruct the compressed image
%
%   input -----------------------------------------------------------------
%       o img : The original image   
%       o cimg : The compressed image
%       o ApList : List of projection matrices for each independent
%       channels
%       o muList : List of mean vectors for each independent channels
%
%   output ----------------------------------------------------------------
%
%       o rimg : The reconstructed image

% ADD CODE HERE: calculate the bitsize of the image
% HINT: Sum up all its elements. You can use the function numel
origSize = 
% END CODE

% ADD CODE HERE: calculate the bitsize of the compressed image
% HINT: Do not forget that ApList and muList are required for
% reconstruction. Their size should also be included here
compressedSize = 
% END CODE

% ADD CODE HERE: Calculate the compression rate
% HINT: one minus the size ratio
cr = 
% END CODE

% convert the size to megabits
compressedSize = compressedSize / 1048576; 
end

