function [d] =  my_distance(x_1, x_2, type)
%MY_DISTANCE Computes the distance between two datapoints (as column vectors)
%   depending on the choosen distance type={'L1','L2','LInf'}
%
%   input -----------------------------------------------------------------
%   
%       o x_1   : (N x 1),  N-dimensional datapoint
%       o x_2   : (N x 1),  N-dimensional datapoint
%       o type  : (string), type of distance {'L1','L2','LInf'}
%
%   output ----------------------------------------------------------------
%
%       o d      : distance between x_1 and x_2 depending on distance
%                  type {'L1','L2','LInf'}
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d = 0;

% ADD CODE HERE
if(strcmp(type,'L1'))
    difference = sum(abs(x_1 - x_2),1);
elseif(strcmp(type,'L2'))
    difference = sqrt(sum(((x_1-x_2).^2),1));
elseif(strcmp(type,'LInf'))
     difference = max(abs(x_1-x_2));
end
d=difference;






% END CODE

end