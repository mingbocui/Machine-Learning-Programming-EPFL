function plotClassificationRegion(model, xTrain, yTrain, featureLabels)
%PLOTCLASSIFICATIONREGION Summary of this function goes here
%   Detailed explanation goes here

%% YOU DON'T HAVE TO CHANGE ANYTHING HERE BUT TRY TO UNDERSTAND HOW IT WORKS

% choose ranges and step size for the grid
ranges = [[min(xTrain(:,1))-.25,max(xTrain(:,1))+.25]; [min(xTrain(:,2))-.25,max(xTrain(:,2))+.25]];
step = 0.01;

% create a grid for the first two features
[x,y] = meshgrid(ranges(1,1):step:ranges(1,2),ranges(2,1):step:ranges(2,2));
data = [x(:), y(:)];

% predict the output labels on the grid
predictedLabels = model.predict(data);

% plot the contour lines of the predictions
z = reshape(predictedLabels, size(x));
contourf(x,y,z);

% define a specific set of colors to be used by the contour function
map = [117/255 112/255 179/255
       27/255 158/255 119/255
       217/255 95/255 2/255];
colormap(map)

hold on;
% plot the 2D samples of the train dataset
plot2DSamples(xTrain, yTrain, featureLabels, [1,2]);
hold off;

xlabel(featureLabels(1));
ylabel(featureLabels(2));
end

