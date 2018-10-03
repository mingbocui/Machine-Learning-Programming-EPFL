function [accuracy] = computeAccuracy(groundTruth, predictedLabels)
% compute the simplest method for accuracy as the ratio of
% right predictions over the total number of samples
accuracy = sum((groundTruth == predictedLabels))/size(groundTruth,1);
%accuracy = evaluateSemanticSegmentation(predictedLabels,groundTruth)
end

