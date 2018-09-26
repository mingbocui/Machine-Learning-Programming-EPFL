function [] = univariateBoxplot(data, classes, featuresLabel)

% extract the number of dimemsions from the data
dim = size(data);
% create a subplot for each features (second dimension) and draw a boxplot of the data
for i=1:dim(2)
    subplot(dim(2)/2, dim(2)/2, i)
    boxplot(data(:,i),classes)
    %On each box, the central mark indicates the median, and the bottom and top edges of the box indicate the 25th and 
    %75th percentiles, respectively. The whiskers extend to the most extreme data points not considered outliers, 
    %and the outliers are plotted individually using the '+' symbol.
    xlabel('Species')
    ylabel(featuresLabel(i))
end

end

