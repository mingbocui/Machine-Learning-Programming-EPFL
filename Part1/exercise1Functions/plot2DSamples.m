function [] = plot2DSamples(data, classes, featuresLabel, axis)

data = data(:,axis)
featuresLabel = featuresLabel(axis)

% create a different plot depending on the given axis
[r,c] = size(axis);

% different feature case
if (r > 1) || (c > 1)

    %using gscatter function to scatter the data by group
    gscatter(data(:,1),data(:,2),classes, 'bgr', 'osd')
    % END CODE

    xlabel(featuresLabel(1));
    ylabel(featuresLabel(2));
    grid on

% if there is only one column of data, using histogram case to illustrate
else
    % set a color for each class
    colors = ['b','g','r'];
    %extract the distinguahed name in classes. For example, there are 3
    %names in classes, then classNames would be a list contains these names
    classNames = unique(classes)
    
    %there are three distiguished name in classes, grp2idx function could encode the different name into number 1,2 3
    classes = grp2idx(classes)
    
    % plot a different histogram for each class
    for i=1:length(classNames)
        % extract different classes with indexes
        indexes = (classes==i)
        histogram(data(indexes), 'FaceAlpha', .7, 'FaceColor', colors(i));
        hold on
    end
    % add the legend and axis title
    legend(classNames) 
    xlabel(featuresLabel);
    ylabel('Counts')
end
end

