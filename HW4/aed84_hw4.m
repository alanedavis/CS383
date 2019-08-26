%% CS 383
% Alan Davis
% Assignment 1 - Part 1

%% Clear All
clear, clc, close all

%% Naive Bayes Classifier
% Read data and separate label from data
dataX = load('spambase.data');
dataY = dataX(:, size(dataX, 2));
dataX(:, size(dataX, 2)) = [];

% Prep and randomize elements in matrix
rng(0);
[rows cols] = size(dataX);
R = randperm(rows);

for i = 1:rows
    inp1(i,:) = dataX(R(i), 1:end);
    inp2(i,:) = dataY(R(i), 1:end);
end

% Get the index for 2/3 of the data
xTrainSet = inp1(1:ceil(rows*(2/3)), :);
yTrainSet = inp2(1:ceil(rows*(2/3)), :);

% Standardize Training Set
trainMean = mean(xTrainSet);
trainStd = std(xTrainSet);
xTrainSet = (xTrainSet - trainMean)./trainStd;

% Remainder 1/3 of data
xTestSet = inp1(1:ceil(rows*(2/3)+1), :);
yTestSet = inp2(1:ceil(rows*(2/3)+1), :);

% Standardize Testing Set with Training
xTestSet = (xTestSet - trainMean)./trainStd;

%Set Aside Spam and Non-Spam Data in Training Phase
xTrainSpam = xTrainSet(find(yTrainSet==1), :);
xTrainNotSpam = xTrainSet(find(yTrainSet==0), :);

% Prior Estimation
priorXSpam = size(xTrainSpam,1)/size(xTrainSet,1);
priorXNotSpam = size(xTrainNotSpam,1)/size(xTrainSet,1);

% Mean
meanXTrainSpam = mean(xTrainSpam);
meanXTrainNotSpam = mean(xTrainNotSpam);

% Std
stdXTrainSpam = std(xTrainSpam);
stdXTrainNotSpam = std(xTrainNotSpam);

% Norm PDF or Gaussian Distribution
normXSpam = normpdf(xTestSet,meanXTrainSpam,stdXTrainSpam);
normXNotSpam = normpdf(xTestSet,meanXTrainNotSpam,stdXTrainNotSpam);

% Maximum Likelihood Estimation
mleXSpam = prod(normXSpam, 2);
mleXNotSpam = prod(normXNotSpam, 2);

% Multiply Maximum Likelihood Estimation
estYSpam = priorXSpam .* mleXSpam;
estYNotSpam = priorXNotSpam .* mleXNotSpam;

% Predictions
predictYTest = zeros(size(yTestSet, 1), 1);

% Labeling Data
label = [];

for i = 1:size(yTestSet, 1)
    if estYSpam(i) > estYNotSpam(i)
        predictYTest(i) = 1;
    else
        predictYTest(i) = 0;
    end
end

for i = 1:size(yTestSet, 1)
    if predictYTest(i) == yTestSet(i) && predictYTest(i) == 1
        label = [label; 'P1'];
    elseif predictYTest(i) == yTestSet(i) && predictYTest(i) == 0
        label = [label; 'N1'];
    elseif predictYTest(i) ~= yTestSet(i) && predictYTest(i) == 1
        label = [label; 'P2'];
    elseif predictYTest(i) ~= yTestSet(i) && predictYTest(i) == 0
        label = [label; 'N2'];
    end
end

% Counts
TP = sum(label=='P1');
TN = sum(label=='N1');
FP = sum(label=='P2');
FN = sum(label=='N2');

% Precision
precision = TP/(TP+FP);
disp('Precision');
disp(precision);

% Recall
recall = TP/(TP+FN);
disp('Recall');
disp(recall);

% F-Measure
fmeasure = (2*precision*recall)/(precision+recall);
disp('F-Measure');
disp(fmeasure);

% Accuracy
accuracy = (TP+TN)/(TP+TN+FP+FN);
disp('Accuracy');
disp(accuracy);
