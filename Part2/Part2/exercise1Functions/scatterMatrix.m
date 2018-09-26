function [] = scatterMatrix(data, classes, featuresLabel)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% plot the matrix and keep the arguments to modify axis titles 
[~,AX] = gplotmatrix(data, [], classes);
for i=1:length(featuresLabel)
    AX(i,1).YLabel.String = featuresLabel(i);
end
for i=1:length(featuresLabel)
    AX(length(featuresLabel),i).XLabel.String = featuresLabel(i);
end
end

