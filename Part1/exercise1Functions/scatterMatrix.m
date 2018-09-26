function [] = scatterMatrix(data, classes,featuresLabel)

[~,AX,bigax] = gplotmatrix(data,[],classes)
% gplotmatrix(x,y,g) creates a matrix of scatter plots. Each individual set of axes in the resulting figure 
% contains a scatter plot of a column of x against a column of y. All plots are grouped by the grouping 
% variable g.x and y are matrices with the same number of rows. If x has p columns and y has q columns, 
% the figure contains a p-by-q matrix of scatter plots. If you omit y or specify it as the empty matrix, [], 
% gplotmatrix creates a square matrix of scatter plots of columns of x against each other.

% [h,ax,bigax] = gplotmatrix(...) returns three arrays of handles. h is an array of handles to the lines on the 
% graphs. ax is a matrix of handles to the axes of the individual plots. bigax is a handle to big (invisible) 
% axes framing the entire plot matrix. These are left as the current axes, so a subsequent title, xlabel, 
% or ylabel command will produce labels that are centered with respect to the entire plot matrix.

for i=1:length(featuresLabel)
    % ADD CODE HERE: set the y labels (1 line)
    AX(i,1).YLabel.String = featuresLabel(i)
    % END CODE
end
for i=1:length(featuresLabel)
    % ADD CODE HERE: set the x labels (1 line)
    AX(length(featuresLabel),i).XLabel.String = featuresLabel(i) 
    % END CODE
end
bigax.XLabel.String="test"
end

