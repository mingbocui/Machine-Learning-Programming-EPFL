function plot2DSamples(data, classes, featuresLabel, exctractedAxis)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% extract the dimensions given in axis
data = data(:, exctractedAxis);
featuresLabel = featuresLabel(exctractedAxis);

% create a different plot depending on the given axis
[r,c] = size(exctractedAxis);

% different feature case
if (r > 1) || (c > 1)
    % plot each sample of the three species
    gscatter(data(:,1), data(:,2), classes, 'bgr', 'osd');
    xlabel(featuresLabel(1));
    ylabel(featuresLabel(2));
    grid on
    
    
% histogram case
else
    % set a color for each class
    colors = ['b','g','r'];
    
    % extract classes names
    classNames = unique(classes);
    
    % Encode the Y vector (each label corresponding to an int)
    classes = grp2idx(classes);
    
    % plot a different histogram for each class
    for i=1:length(classNames)
        % extract the indexes corresponding to the current class
        indexes = (classes == i);
        
        % plot an histogram of the corresponding samples
        histogram(data(indexes), 'FaceAlpha', .7, 'FaceColor', colors(i));
        hold on
    end
    
    % add the legend and axis title
    legend(classNames) 
    xlabel(featuresLabel);
    ylabel('Counts')
end
end

