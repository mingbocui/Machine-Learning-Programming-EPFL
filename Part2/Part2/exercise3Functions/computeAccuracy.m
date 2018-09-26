function [accuracy] = computeAccuracy(groundTruth, predictedLabels)
%COMPUTEACCURACY Summary of this function goes here
%   Detailed explanation goes here

% ADD CODEH HERE: compute the simplest method for accuracy as the ratio of
% right predictions over the total number of samples
% HINT: can you it in one line? For more lisibility consider outputing a
% pourcentage
accuracy = sum((groundTruth == predictedLabels))/size(groundTruth,1);
%accuracy = evaluateSemanticSegmentation(predictedLabels,groundTruth)
% END CODE
end

